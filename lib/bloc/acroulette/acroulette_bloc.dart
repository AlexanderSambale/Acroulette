import 'dart:collection';
import 'dart:math';

import 'package:acroulette/bloc/mode/mode_bloc.dart';
import 'package:acroulette/bloc/transition/transition_bloc.dart';
import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/bloc/washing_machine/washing_machine_bloc.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/models/entities/settings_pair.dart';
import 'package:acroulette/db_controller.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';

part 'acroulette_event.dart';
part 'acroulette_state.dart';

class AcrouletteBloc extends Bloc<AcrouletteEvent, BaseAcrouletteState> {
  final VoiceRecognitionBloc voiceRecognitionBloc;
  final TtsBloc ttsBloc;
  final DBController dbController;

  late final TransitionBloc transitionBloc;
  late final ModeBloc modeBloc;
  late final WashingMachineBloc washingMachineBloc;

  late RegExp rNextPosition;
  late RegExp rNewPosition;
  late RegExp rPreviousPosition;
  late RegExp rCurrentPosition;

  AcrouletteBloc(this.ttsBloc, this.dbController, this.voiceRecognitionBloc)
      : super(AcrouletteInitialState()) {
    on<AcrouletteStart>((event, emit) {
      dbController.putSettingsPairValueByKey(playingKey, "true");
      voiceRecognitionBloc.add(VoiceRecognitionStart(
          onData, () => onRecognitionStarted(dbController)));
      emit(AcrouletteInitModel());
    });
    on<AcrouletteInitModelEvent>((event, emit) {
      emit(AcrouletteModelInitiatedState());
    });
    on<AcrouletteRecognizeCommand>((event, emit) {
      recognizeCommand(event.command);
    });
    on<AcrouletteCommandRecognizedEvent>((event, emit) {
      _speak(event.currentFigure);
      emit(AcrouletteCommandRecognizedState(event.currentFigure,
          previousFigure: event.previousFigure,
          nextFigure: event.nextFigure,
          mode: mode));
    });
    on<AcrouletteStop>((event, emit) {
      dbController.putSettingsPairValueByKey(playingKey, "false");
      voiceRecognitionBloc.add(VoiceRecognitionStop());
      emit(AcrouletteModelInitiatedState());
    });
    on<AcrouletteTransition>((event, emit) {
      switch (event.transition) {
        case newPosition:
          transitionBloc.add(NewTransitionEvent(dbController.positions));
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
    on<AcrouletteChangeMode>((event, emit) async {
      if (mode == event.mode) return;
      var positions = <String>[];
      if (event.mode == acroulette) {
        positions = dbController.positions;
        modeBloc.add(ModeChange(
            event.mode,
            () => transitionBloc
                .add(InitAcrouletteTransitionEvent(positions, false))));
      }
      if (event.mode == washingMachine) {
        positions = await dbController.flowPositions();
        modeBloc.add(ModeChange(
            event.mode,
            () =>
                transitionBloc.add(InitFlowTransitionEvent(positions, true))));
      }
      emit(AcrouletteFlowState(positions.first));
    });

    on<AcrouletteChangeMachine>((event, emit) {
      if (machine == event.machine) return;
      washingMachineBloc.add(
        WashingMachineChange(
          event.machine,
          () async => transitionBloc.add(
            InitFlowTransitionEvent(await dbController.flowPositions(), true),
          ),
        ),
      );
      emit(AcrouletteFlowState(event.machine));
    });
    // initialize blocs
    modeBloc = ModeBloc(dbController);
    washingMachineBloc = WashingMachineBloc(dbController);

    // initialize transitionBloc
    transitionBloc = TransitionBloc(onTransitionChange, Random());
    dbController.getSettingsPairValueByKey(playingKey).then((value) {
      if (value == "true") {
        add(AcrouletteStart());
      }
    });

    // when Model is loaded call onInitiated
    if (voiceRecognitionBloc.isDisabled) {
      onInitiated();
    } else {
      voiceRecognitionBloc.initialize(onInitiated);
    }

    // get settings
    HashMap<String, String> settingsMap =
        SettingsPair.toMap(dbController.settings);

    // set regex for voice commands
    rNextPosition = RegExp(settingsMap[nextPosition] ?? nextPosition);
    rNewPosition = RegExp(settingsMap[newPosition] ?? newPosition);
    rPreviousPosition =
        RegExp(settingsMap[previousPosition] ?? previousPosition);
    rCurrentPosition = RegExp(settingsMap[currentPosition] ?? currentPosition);
  }

  String get mode {
    return modeBloc.mode;
  }

  String get machine {
    return washingMachineBloc.machine;
  }

  void onTransitionChange(TransitionStatus status) {
    if (!voiceRecognitionBloc.state.isRecognizing &&
        voiceRecognitionBloc.isModelLoaded) return;
    if (status == TransitionStatus.created ||
        status == TransitionStatus.next ||
        status == TransitionStatus.current ||
        status == TransitionStatus.previous) {
      String currentFigure = transitionBloc.currentFigure();
      String previousFigure = transitionBloc.previousFigure();
      String nextFigure = transitionBloc.nextFigure();
      add(AcrouletteCommandRecognizedEvent(currentFigure,
          previousFigure: previousFigure, nextFigure: nextFigure));
    }
  }

  void onData(dynamic event) {
    add(AcrouletteRecognizeCommand(event));
  }

  void onInitiated() {
    add(AcrouletteInitModelEvent());
  }

  Future<void> setTransitionsDependingOnMode(DBController dbController) async {
    if (mode == washingMachine) {
      transitionBloc.add(
          InitFlowTransitionEvent(await dbController.flowPositions(), true));
    }
    if (mode == acroulette) {
      transitionBloc
          .add(InitAcrouletteTransitionEvent(dbController.positions, false));
    }
  }

  void onRecognitionStarted(DBController dbController) {
    setTransitionsDependingOnMode(dbController);
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
    if (ttsBloc.notAvailable) return;
    await ttsBloc.speak(text);
  }
}
