import 'dart:math';

import 'package:acroulette/bloc/mode/mode_bloc.dart';
import 'package:acroulette/bloc/transition/transition_bloc.dart';
import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/bloc/washing_machine/washing_machine_bloc.dart';
import 'package:acroulette/constants/model.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/domain_layer/flow_node_repository.dart';
import 'package:acroulette/domain_layer/node_repository.dart';
import 'package:acroulette/domain_layer/settings_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';

part 'acroulette_event.dart';
part 'acroulette_state.dart';

class AcrouletteBloc extends Bloc<AcrouletteEvent, BaseAcrouletteState> {
  final VoiceRecognitionBloc voiceRecognitionBloc;
  final TtsBloc ttsBloc;
  final NodeRepository nodeRepository;
  final SettingsRepository settingsRepository;
  final FlowNodeRepository flowNodeRepository;

  late final TransitionBloc transitionBloc;
  late final ModeBloc modeBloc;
  late final WashingMachineBloc washingMachineBloc;

  RegExp get rNextPosition => RegExp(settingsRepository.get(nextPosition));
  RegExp get rNewPosition => RegExp(settingsRepository.get(nextPosition));
  RegExp get rPreviousPosition => RegExp(settingsRepository.get(nextPosition));
  RegExp get rCurrentPosition => RegExp(settingsRepository.get(nextPosition));

  AcrouletteBloc({
    required this.ttsBloc,
    required this.nodeRepository,
    required this.settingsRepository,
    required this.flowNodeRepository,
    required this.voiceRecognitionBloc,
  }) : super(AcrouletteInitialState()) {
    on<AcrouletteStart>((event, emit) async {
      await settingsRepository.putSettingsPairValueByKey(playingKey, "true");
      voiceRecognitionBloc.add(VoiceRecognitionStart(
          onData, () async => await onRecognitionStarted()));
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
    on<AcrouletteStop>((event, emit) async {
      await settingsRepository.putSettingsPairValueByKey(playingKey, "false");
      voiceRecognitionBloc.add(VoiceRecognitionStop());
      emit(AcrouletteModelInitiatedState());
    });
    on<AcrouletteTransition>((event, emit) {
      switch (event.transition) {
        case newPosition:
          transitionBloc.add(NewTransitionEvent(nodeRepository.positions));
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
        positions = nodeRepository.positions;
        modeBloc.add(ModeChange(
            event.mode,
            () => transitionBloc
                .add(InitAcrouletteTransitionEvent(positions, false))));
      }
      if (event.mode == washingMachine) {
        positions = await flowPositions();
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
            InitFlowTransitionEvent(await flowPositions(), true),
          ),
        ),
      );
      emit(AcrouletteFlowState(event.machine));
    });
    // initialize blocs
    modeBloc = ModeBloc(settingsRepository);
    washingMachineBloc = WashingMachineBloc(settingsRepository);

    // initialize transitionBloc
    transitionBloc = TransitionBloc(onTransitionChange, Random());
    if (settingsRepository.get(playingKey) == "true") {
      add(AcrouletteStart());
    }

    // when Model is loaded call onInitiated
    if (voiceRecognitionBloc.isDisabled) {
      onInitiated();
    } else {
      voiceRecognitionBloc.initialize(onInitiated);
    }
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

  Future<List<String>> flowPositions() async {
    return await flowNodeRepository.flowPositions(
      int.parse(
        await settingsRepository.getSettingsPairValueByKey(flowIndex),
      ),
    );
  }

  Future<void> setTransitionsDependingOnMode() async {
    if (mode == washingMachine) {
      transitionBloc.add(InitFlowTransitionEvent(await flowPositions(), true));
    }
    if (mode == acroulette) {
      transitionBloc
          .add(InitAcrouletteTransitionEvent(nodeRepository.positions, false));
    }
  }

  Future<void> onRecognitionStarted() async {
    await setTransitionsDependingOnMode();
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
