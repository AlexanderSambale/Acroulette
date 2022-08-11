import 'dart:collection';

import 'package:acroulette/bloc/transition/transition_bloc.dart';
import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/constants/commands.dart';
import 'package:acroulette/main.dart';
import 'package:acroulette/models/SettingsPair.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';

part 'acroulette_event.dart';
part 'acroulette_state.dart';

class AcrouletteBloc extends Bloc<AcrouletteEvent, BaseAcrouletteState> {
  AcrouletteBloc(this.flutterTts, List<SettingsPair> settings)
      : super(AcrouletteInitialState()) {
    voiceRecognitionBloc = VoiceRecognitionBloc(onInitiated);
    settingsMap = SettingsPair.toMap(settings);
    rNextPosition = RegExp(settingsMap[NEXT_POSITION] ?? NEXT_POSITION);
    rNewPosition = RegExp(settingsMap[NEW_POSITION] ?? NEW_POSITION);
    rPreviousPosition =
        RegExp(settingsMap[PREVIOUS_POSITION] ?? PREVIOUS_POSITION);
    rCurrentPosition =
        RegExp(settingsMap[CURRENT_POSITION] ?? CURRENT_POSITION);
    transitionBloc = TransitionBloc(
        onTransitionChange,
        objectbox.positionBox
            .getAll()
            .map<String>((element) => element.name)
            .toList());

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
    on<AcrouletteCommandRecognizedEvent>((event, emit) =>
        {emit(AcrouletteCommandRecognizedState(event.currentFigure))});
    on<AcrouletteStop>((event, emit) {
      voiceRecognitionBloc.add(VoiceRecognitionStop());
      emit(AcrouletteInitialState());
    });
  }

  late final TransitionBloc transitionBloc;
  late VoiceRecognitionBloc voiceRecognitionBloc;
  final ttsBloc = TtsBloc();
  final FlutterTts flutterTts;
  late HashMap<String, String> settingsMap;

  late RegExp rNextPosition;
  late RegExp rNewPosition;
  late RegExp rPreviousPosition;
  late RegExp rCurrentPosition;

  void onTransitionChange(TransitionStatus status) {
    if (status == TransitionStatus.created ||
        status == TransitionStatus.next ||
        status == TransitionStatus.current ||
        status == TransitionStatus.previous) {
      String currentFigure = transitionBloc.currentFigure();
      add(AcrouletteCommandRecognizedEvent(currentFigure));
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

    if (rNewPosition.hasMatch(text)) {
      transitionBloc.add(NewTransitionEvent());
      return;
    }
    if (rNextPosition.hasMatch(text)) {
      transitionBloc.add(NextTransitionEvent());
      return;
    }
    if (rPreviousPosition.hasMatch(text)) {
      transitionBloc.add(PreviousTransitionEvent());
      return;
    }
    if (rCurrentPosition.hasMatch(text)) {
      transitionBloc.add(CurrentTransitionEvent());
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
