import 'dart:collection';

import 'package:acroulette/bloc/mode/mode_bloc.dart';
import 'package:acroulette/bloc/transition/transition_bloc.dart';
import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/constants/model.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/models/settings_pair.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';

part 'acroulette_event.dart';
part 'acroulette_state.dart';

class AcrouletteBloc extends Bloc<AcrouletteEvent, BaseAcrouletteState> {
  AcrouletteBloc(this.flutterTts, ObjectBox objectbox)
      : super(AcrouletteInitialState()) {
    voiceRecognitionBloc = VoiceRecognitionBloc(onInitiated);
    HashMap<String, String> settingsMap =
        SettingsPair.toMap(objectbox.settingsBox.getAll());
    modeBloc = ModeBloc(objectbox);
    List<String> possibleFigures = [];
    rNextPosition = RegExp(settingsMap[nextPosition] ?? nextPosition);
    rNewPosition = RegExp(settingsMap[newPosition] ?? newPosition);
    rPreviousPosition =
        RegExp(settingsMap[previousPosition] ?? previousPosition);
    rCurrentPosition = RegExp(settingsMap[currentPosition] ?? currentPosition);
    if (mode == acroulette) {
      possibleFigures = objectbox.positionBox
          .getAll()
          .map<String>((element) => element.name)
          .toList();
    }
    transitionBloc = TransitionBloc(onTransitionChange, possibleFigures);
    if (mode == washingMachine) {
      List<String> figures = objectbox.flowNodeBox
          .get(int.parse(objectbox.getSettingsPairValueByKey(flowIndex)))!
          .positions;
      transitionBloc.add(InitFlowTransitionEvent(figures));
    }

    on<AcrouletteStart>((event, emit) {
      voiceRecognitionBloc.add(
          VoiceRecognitionStart(onData, onInitiated, onRecognitionStarted));
      emit(AcrouletteInitModel());
    });
    on<AcrouletteInitModelEvent>((event, emit) {
      emit(AcrouletteModelInitiatedState());
    });
    on<AcrouletteStartVoiceRecognitionEvent>((event, emit) {
      emit(AcrouletteVoiceRecognitionStartedState());
    });
    on<AcrouletteRecognizeCommand>(
        (event, emit) => {recognizeCommand(event.command)});
    on<AcrouletteCommandRecognizedEvent>((event, emit) => {
          emit(AcrouletteCommandRecognizedState(event.currentFigure,
              previousFigure: event.previousFigure,
              nextFigure: event.nextFigure,
              mode: mode))
        });
    on<AcrouletteStop>((event, emit) {
      voiceRecognitionBloc.add(VoiceRecognitionStop());
      emit(AcrouletteInitialState());
    });
    on<AcrouletteTransition>((event, emit) {
      switch (event.transition) {
        case newPosition:
          transitionBloc.add(NewTransitionEvent());
          break;
        case nextPosition:
          transitionBloc.add(NextTransitionEvent());
          break;
        case previousPosition:
          transitionBloc.add(PreviousTransitionEvent());
          break;
        case currentPosition:
          transitionBloc.add(CurrentTransitionEvent());
          break;
      }
    });
    on<AcrouletteChangeMode>((event, emit) {
      if (event.mode == acroulette) {
        modeBloc.add(ModeChange(event.mode,
            () => transitionBloc.add(InitAcrouletteTransitionEvent())));
      }
      if (event.mode == washingMachine) {
        modeBloc.add(ModeChange(event.mode,
            () => transitionBloc.add(InitFlowTransitionEvent(event.figures))));
      }
      emit(AcrouletteInitialState());
    });
  }

  late final TransitionBloc transitionBloc;
  late VoiceRecognitionBloc voiceRecognitionBloc;
  final ttsBloc = TtsBloc();
  final FlutterTts flutterTts;
  late final ModeBloc modeBloc;

  late RegExp rNextPosition;
  late RegExp rNewPosition;
  late RegExp rPreviousPosition;
  late RegExp rCurrentPosition;

  String get mode {
    return modeBloc.mode;
  }

  void onTransitionChange(TransitionStatus status) {
    if (status == TransitionStatus.created ||
        status == TransitionStatus.next ||
        status == TransitionStatus.current ||
        status == TransitionStatus.previous) {
      String currentFigure = transitionBloc.currentFigure();
      String previousFigure = transitionBloc.previousFigure();
      String nextFigure = transitionBloc.nextFigure();
      add(AcrouletteCommandRecognizedEvent(currentFigure,
          previousFigure: previousFigure, nextFigure: nextFigure));
      _speak(currentFigure);
    }
  }

  void onData(dynamic event) {
    add(AcrouletteRecognizeCommand(event));
  }

  void onInitiated() {
    add(AcrouletteInitModelEvent());
  }

  void onRecognitionStarted() {
    add(AcrouletteStartVoiceRecognitionEvent());
  }

  void recognizeCommand(String command) {
    final Map<String, dynamic> commandMapped = jsonDecode(command);
    final text = commandMapped["text"];

    if (appMode != washingMachine && rNewPosition.hasMatch(text)) {
      add(AcrouletteTransition(newPosition));
      return;
    }
    if (rNextPosition.hasMatch(text)) {
      add(AcrouletteTransition(nextPosition));
      return;
    }
    if (rPreviousPosition.hasMatch(text)) {
      add(AcrouletteTransition(previousPosition));
      return;
    }
    if (rCurrentPosition.hasMatch(text)) {
      add(AcrouletteTransition(currentPosition));
      return;
    }
  }

  Future _speak(String text) async {
    double volume = 0.5;
    double pitch = 1.0;
    double rate = 0.5;
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    await flutterTts.speak(text);
  }
}
