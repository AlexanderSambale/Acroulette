import 'dart:math';

import 'package:acroulette/bloc/acroulette/acroulette_settings.dart';
import 'package:acroulette/bloc/transition/transition_bloc.dart';
import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/constants/model.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/domain_layer/flow_node_repository.dart';
import 'package:acroulette/domain_layer/node_repository.dart';
import 'package:acroulette/domain_layer/settings_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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

  AcrouletteBloc(
      {required this.ttsBloc,
      required this.nodeRepository,
      required this.settingsRepository,
      required this.flowNodeRepository,
      required this.voiceRecognitionBloc,
      AcrouletteInitialState? initialState})
      : super(
          initialState ??
              AcrouletteInitialState(
                settings: generateInitialSettings(
                  settingsRepository,
                  flowNodeRepository,
                ),
              ),
        ) {
    on<AcrouletteStart>((event, emit) async {
      await settingsRepository.putSettingsPairValueByKey(playingKey, "true");
      voiceRecognitionBloc.add(VoiceRecognitionStart(
          onData, () => onRecognitionStarted(state.settings.mode)));
      emit(AcrouletteInitModel(settings: state.settings.copyWith()));
    });
    on<AcrouletteInitModelEvent>((event, emit) {
      if (settingsRepository.get(playingKey) == "false") {
        emit(
          AcrouletteModelInitiatedState(settings: state.settings.copyWith()),
        );
      } else {
        add(AcrouletteStart());
      }
    });
    on<AcrouletteRecognizeCommand>((event, emit) {
      recognizeCommand(event.command, state.settings);
    });
    on<AcrouletteCommandRecognizedEvent>((event, emit) {
      _speak(event.currentFigure);
      emit(AcrouletteCommandRecognizedState(
        currentFigure: event.currentFigure,
        previousFigure: event.previousFigure,
        nextFigure: event.nextFigure,
        settings: state.settings.copyWith(),
      ));
    });
    on<AcrouletteStop>((event, emit) async {
      await settingsRepository.putSettingsPairValueByKey(playingKey, "false");
      voiceRecognitionBloc.add(VoiceRecognitionStop());
      emit(AcrouletteModelInitiatedState(
        settings: state.settings.copyWith(),
      ));
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
    on<AcrouletteChangeMode>((event, emit) {
      if (state.settings.mode == event.mode) return;
      var positions = <String>[];
      if (event.mode == acroulette) {
        positions = nodeRepository.positions;
        transitionBloc.add(InitAcrouletteTransitionEvent(positions, false));
      }
      if (event.mode == washingMachine) {
        positions = flowPositions();
        transitionBloc.add(InitFlowTransitionEvent(positions, true));
      }
      emit(AcrouletteFlowState(
        settings: state.settings.copyWith(mode: event.mode),
        flowName: positions.first,
      ));
    });

    on<AcrouletteChangeMachine>((event, emit) {
      if (state.settings.machine == event.machine) return;
      transitionBloc.add(
        InitFlowTransitionEvent(flowPositions(), true),
      );
      emit(AcrouletteFlowState(
        settings: state.settings.copyWith(machine: event.machine),
        flowName: '',
      ));
    });

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

  List<String> flowPositions() {
    return flowNodeRepository.flowPositions(
      int.parse(
        settingsRepository.get(flowIndex),
      ),
    );
  }

  void setTransitionsDependingOnMode(String mode) {
    if (mode == washingMachine) {
      transitionBloc.add(InitFlowTransitionEvent(flowPositions(), true));
    }
    if (mode == acroulette) {
      transitionBloc
          .add(InitAcrouletteTransitionEvent(nodeRepository.positions, false));
    }
  }

  void onRecognitionStarted(String mode) {
    setTransitionsDependingOnMode(mode);
  }

  void recognizeCommand(String command, AcrouletteSettings settings) {
    final Map<String, dynamic> commandMapped = jsonDecode(command);
    final text = commandMapped["text"];

    if (settings.mode != washingMachine &&
        settings.rNewPosition.hasMatch(text)) {
      add(AcrouletteTransition(newPosition));
      return;
    }
    if (settings.rNextPosition.hasMatch(text)) {
      add(AcrouletteTransition(nextPosition));
      return;
    }
    if (settings.rPreviousPosition.hasMatch(text)) {
      add(AcrouletteTransition(previousPosition));
      return;
    }
    if (settings.rCurrentPosition.hasMatch(text)) {
      add(AcrouletteTransition(currentPosition));
      return;
    }
  }

  Future _speak(String text) async {
    if (ttsBloc.notAvailable) return;
    await ttsBloc.speak(text);
  }

  static AcrouletteSettings generateInitialSettings(
      SettingsRepository settingsRepository,
      FlowNodeRepository flowNodeRepository) {
    return AcrouletteSettings(
      rNextPosition: RegExp(settingsRepository.get(nextPosition)),
      rNewPosition: RegExp(settingsRepository.get(nextPosition)),
      rPreviousPosition: RegExp(settingsRepository.get(nextPosition)),
      rCurrentPosition: RegExp(settingsRepository.get(nextPosition)),
      mode: settingsRepository.get(appMode),
      machine: flowNodeRepository.flows.first.name,
    );
  }
}
