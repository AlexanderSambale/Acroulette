import 'package:acroulette/bloc/acroulette/acroulette_bloc.dart';
import 'package:acroulette/bloc/acroulette/acroulette_settings.dart';
import 'package:acroulette/bloc/transition/transition_bloc.dart';
import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/domain_layer/flow_node_repository.dart';
import 'package:acroulette/domain_layer/node_repository.dart';
import 'package:acroulette/domain_layer/settings_repository.dart';
import 'package:acroulette/storage_provider.dart';
import 'package:acroulette/models/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:mocktail/mocktail.dart';

class MockFlutterTts extends Mock implements TtsBloc {}

class MockVoiceRecognitionBloc extends Mock implements VoiceRecognitionBloc {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  group('acroulette bloc', () {
    late AcrouletteBloc acrouletteBloc;
    late AppDatabase database;
    late StorageProvider storageProvider;
    late TtsBloc ttsBloc;
    late VoiceRecognitionBloc voiceRecognitionBloc;
    late NodeRepository nodeRepository;
    late FlowNodeRepository flowNodeRepository;
    late SettingsRepository settingsRepository;

    setUp(() {
      return Future(() async {
        database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
        storageProvider = await StorageProvider.create(database);
        nodeRepository = NodeRepository(storageProvider);
        flowNodeRepository = FlowNodeRepository(storageProvider);
        settingsRepository = SettingsRepository(storageProvider);
        await nodeRepository.initialize();
        await flowNodeRepository.initialize();
        await settingsRepository.initialize();
        ttsBloc = MockFlutterTts();
        voiceRecognitionBloc = MockVoiceRecognitionBloc();
        when(() => voiceRecognitionBloc.isDisabled).thenReturn(false);
        when(() => ttsBloc.notAvailable).thenReturn(true);
        acrouletteBloc = AcrouletteBloc(
          ttsBloc: ttsBloc,
          nodeRepository: nodeRepository,
          settingsRepository: settingsRepository,
          flowNodeRepository: flowNodeRepository,
          voiceRecognitionBloc: voiceRecognitionBloc,
        );
      });
    });

    tearDown(() {
      return Future(() async {
        await database.close();
        await acrouletteBloc.close();
      });
    });

    test('initial state is AcrouletteInitialState()', () {
      AcrouletteSettings settings = AcrouletteBloc.generateInitialSettings(
        settingsRepository,
        flowNodeRepository,
      );
      expect(acrouletteBloc.state, AcrouletteInitialState(settings: settings));
    });

    blocTest<AcrouletteBloc, BaseAcrouletteState>(
      'emits [AcrouletteInitModel()] when AcrouletteStart is added',
      build: () => acrouletteBloc,
      act: (bloc) => bloc.add(AcrouletteStart()),
      expect: () {
        AcrouletteSettings settings = AcrouletteBloc.generateInitialSettings(
          settingsRepository,
          flowNodeRepository,
        );
        return [AcrouletteInitModel(settings: settings)];
      },
      verify: (bloc) async => expect(
        await settingsRepository.getSettingsPairValueByKey(playingKey),
        "true",
      ),
      wait: const Duration(milliseconds: 100),
    );

    blocTest<AcrouletteBloc, BaseAcrouletteState>(
      'emits [AcrouletteModelInitiatedState()] when AcrouletteStop is added',
      build: () => acrouletteBloc,
      act: (bloc) => bloc.add(AcrouletteStop()),
      expect: () {
        AcrouletteSettings settings = AcrouletteBloc.generateInitialSettings(
          settingsRepository,
          flowNodeRepository,
        );
        return [AcrouletteModelInitiatedState(settings: settings)];
      },
      verify: (bloc) async => expect(
        await settingsRepository.getSettingsPairValueByKey(playingKey),
        "false",
      ),
      wait: const Duration(milliseconds: 100),
    );

    blocTest<AcrouletteBloc, BaseAcrouletteState>(
      'emits [AcrouletteModelInitiatedState()] when AcrouletteInitModelEvent is added',
      build: () => acrouletteBloc,
      act: (bloc) => bloc.add(AcrouletteInitModelEvent()),
      expect: () {
        AcrouletteSettings settings = AcrouletteBloc.generateInitialSettings(
          settingsRepository,
          flowNodeRepository,
        );
        return [AcrouletteModelInitiatedState(settings: settings)];
      },
    );

    group('transitions', () {
      blocTest<AcrouletteBloc, BaseAcrouletteState>(
          'new Position ends in AcrouletteCommandRecognizedState with mode acroulette',
          build: () => acrouletteBloc,
          seed: () {
            AcrouletteSettings settings =
                AcrouletteBloc.generateInitialSettings(
              settingsRepository,
              flowNodeRepository,
            ).copyWith(mode: acroulette);
            return AcrouletteCommandRecognizedState(
              currentFigure: '',
              previousFigure: '',
              nextFigure: '',
              settings: settings,
            );
          },
          act: (bloc) {
            when(() => bloc.voiceRecognitionBloc.state)
                .thenReturn(const VoiceRecognitionState(true));
            when(() => bloc.ttsBloc.speak(any())).thenAnswer((_) async {});
            bloc.add(AcrouletteTransition(newPosition));
          },
          expect: () => [
                isA<AcrouletteCommandRecognizedState>()
                    .having((state) => state.currentFigure, 'currentFigure',
                        isA<String>())
                    .having((state) => state.nextFigure, 'nextFigure', '')
                    .having(
                        (state) => state.previousFigure, 'previousFigure', '')
                    .having((state) => state.settings.mode, 'mode', acroulette),
              ]);

      blocTest<AcrouletteBloc, BaseAcrouletteState>(
          'next Position, current Position and previous Position',
          build: () => acrouletteBloc,
          seed: () {
            AcrouletteSettings settings =
                AcrouletteBloc.generateInitialSettings(
              settingsRepository,
              flowNodeRepository,
            ).copyWith(mode: acroulette);
            return AcrouletteCommandRecognizedState(
              currentFigure: '',
              previousFigure: '',
              nextFigure: '',
              settings: settings,
            );
          },
          act: (bloc) async {
            when(() => bloc.voiceRecognitionBloc.state)
                .thenReturn(const VoiceRecognitionState(true));
            when(() => bloc.ttsBloc.speak(any())).thenAnswer((_) async {});
            bloc.transitionBloc.add(InitFlowTransitionEvent(
              flowNodeRepository.flowPositions(1),
              true,
            ));
            bloc.add(AcrouletteTransition(nextPosition));
            bloc.add(AcrouletteTransition(currentPosition));
            bloc.add(AcrouletteTransition(previousPosition));
          },
          expect: () => [
                isA<AcrouletteCommandRecognizedState>()
                    .having((state) => state.currentFigure, 'currentFigure',
                        'ninja side star')
                    .having((state) => state.nextFigure, 'nextFigure',
                        'reverse bird')
                    .having((state) => state.previousFigure, 'previousFigure',
                        'buddha'),
                isA<AcrouletteCommandRecognizedState>()
                    .having((state) => state.currentFigure, 'currentFigure',
                        'reverse bird')
                    .having((state) => state.nextFigure, 'nextFigure',
                        'ninja side star')
                    .having((state) => state.previousFigure, 'previousFigure',
                        'ninja side star'),
                isA<AcrouletteCommandRecognizedState>()
                    .having((state) => state.currentFigure, 'currentFigure',
                        'reverse bird')
                    .having((state) => state.nextFigure, 'nextFigure',
                        'ninja side star')
                    .having((state) => state.previousFigure, 'previousFigure',
                        'ninja side star'),
                isA<AcrouletteCommandRecognizedState>()
                    .having((state) => state.currentFigure, 'currentFigure',
                        'ninja side star')
                    .having((state) => state.nextFigure, 'nextFigure',
                        'reverse bird')
                    .having((state) => state.previousFigure, 'previousFigure',
                        'buddha'),
              ]);
    });

    group('ChangeMode', () {
      blocTest<AcrouletteBloc, BaseAcrouletteState>(
        'new Position ends in AcrouletteCommandRecognizedState with mode acroulette',
        build: () => acrouletteBloc,
        seed: () {
          AcrouletteSettings settings = AcrouletteBloc.generateInitialSettings(
            settingsRepository,
            flowNodeRepository,
          ).copyWith(mode: washingMachine);
          return AcrouletteCommandRecognizedState(
            currentFigure: '',
            previousFigure: '',
            nextFigure: '',
            settings: settings,
          );
        },
        act: (bloc) {
          when(() => bloc.voiceRecognitionBloc.state)
              .thenReturn(const VoiceRecognitionState(true));
          when(() => bloc.ttsBloc.speak(any())).thenAnswer((_) async {});
          bloc.add(AcrouletteChangeMode(acroulette));
        },
        wait: const Duration(milliseconds: 100),
        expect: () => [
          isA<AcrouletteChangedModeState>()
              .having((state) => state.settings.mode, 'mode', acroulette),
          isA<AcrouletteCommandRecognizedState>()
              .having((state) => state.currentFigure, 'currentFigure',
                  isA<String>())
              .having((state) => state.nextFigure, 'nextFigure', '')
              .having((state) => state.previousFigure, 'previousFigure', '')
              .having((state) => state.settings.mode, 'mode', acroulette),
        ],
      );

      blocTest<AcrouletteBloc, BaseAcrouletteState>(
        'new Position ends in AcrouletteCommandRecognizedState with mode washingMachine',
        build: () => acrouletteBloc,
        act: (bloc) {
          when(() => bloc.voiceRecognitionBloc.state)
              .thenReturn(const VoiceRecognitionState(true));
          when(() => bloc.ttsBloc.speak(any())).thenAnswer((_) async {});
          bloc.add(AcrouletteChangeMode(washingMachine));
        },
        wait: const Duration(milliseconds: 100),
        expect: () => [
          isA<AcrouletteChangedModeState>()
              .having((state) => state.settings.mode, 'mode', washingMachine),
          isA<AcrouletteCommandRecognizedState>()
              .having((state) => state.currentFigure, 'currentFigure',
                  'ninja side star')
              .having((state) => state.nextFigure, 'nextFigure', 'reverse bird')
              .having(
                  (state) => state.previousFigure, 'previousFigure', 'buddha')
              .having((state) => state.settings.mode, 'mode', washingMachine),
        ],
      );
    });
  });
}
