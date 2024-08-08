import 'package:acroulette/bloc/acroulette/acroulette_bloc.dart';
import 'package:acroulette/bloc/transition/transition_bloc.dart';
import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/db_controller.dart';
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
    late DBController dbController;
    late TtsBloc ttsBloc;
    late VoiceRecognitionBloc voiceRecognitionBloc;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
      dbController = await DBController.create(database);
      ttsBloc = MockFlutterTts();
      voiceRecognitionBloc = MockVoiceRecognitionBloc();
      when(() => voiceRecognitionBloc.isDisabled).thenReturn(false);
      when(() => ttsBloc.notAvailable).thenReturn(true);
      acrouletteBloc = AcrouletteBloc(
        ttsBloc,
        dbController,
        voiceRecognitionBloc,
      );
    });

    tearDown(() async {
      await database.close();
      await acrouletteBloc.close();
    });

    test('initial state is AcrouletteInitialState()', () {
      expect(acrouletteBloc.state, AcrouletteInitialState());
    });

    blocTest<AcrouletteBloc, BaseAcrouletteState>(
      'emits [AcrouletteInitModel()] when AcrouletteStart is added',
      build: () => acrouletteBloc,
      act: (bloc) => bloc.add(AcrouletteStart()),
      expect: () => [AcrouletteInitModel()],
      verify: (bloc) async => expect(
        await dbController.getSettingsPairValueByKey(playingKey),
        "true",
      ),
      wait: const Duration(milliseconds: 100),
    );

    blocTest<AcrouletteBloc, BaseAcrouletteState>(
      'emits [AcrouletteModelInitiatedState()] when AcrouletteStop is added',
      build: () => acrouletteBloc,
      act: (bloc) => bloc.add(AcrouletteStop()),
      expect: () => [AcrouletteModelInitiatedState()],
      verify: (bloc) async => expect(
          await dbController.getSettingsPairValueByKey(playingKey), "false"),
      wait: const Duration(milliseconds: 100),
    );

    blocTest<AcrouletteBloc, BaseAcrouletteState>(
      'emits [AcrouletteModelInitiatedState()] when AcrouletteInitModelEvent is added',
      build: () => acrouletteBloc,
      act: (bloc) => bloc.add(AcrouletteInitModelEvent()),
      expect: () => [AcrouletteModelInitiatedState()],
    );

    group('transitions', () {
      blocTest<AcrouletteBloc, BaseAcrouletteState>(
          'new Position ends in AcrouletteCommandRecognizedState with mode acroulette',
          build: () => acrouletteBloc,
          seed: () => const AcrouletteCommandRecognizedState('',
              previousFigure: '', nextFigure: '', mode: acroulette),
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
                    .having((state) => state.mode, 'mode', acroulette),
              ]);

      blocTest<AcrouletteBloc, BaseAcrouletteState>(
          'next Position, current Position and previous Position',
          build: () => acrouletteBloc,
          seed: () => const AcrouletteCommandRecognizedState('',
              previousFigure: '', nextFigure: '', mode: acroulette),
          act: (bloc) async {
            when(() => bloc.voiceRecognitionBloc.state)
                .thenReturn(const VoiceRecognitionState(true));
            when(() => bloc.ttsBloc.speak(any())).thenAnswer((_) async {});
            bloc.transitionBloc.add(InitFlowTransitionEvent(
                await dbController.flowPositions(), true));
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
          build: () {
            dbController.putSettingsPairValueByKey(appMode, acroulette);
            return acrouletteBloc;
          },
          act: (bloc) {
            when(() => bloc.voiceRecognitionBloc.state)
                .thenReturn(const VoiceRecognitionState(true));
            when(() => bloc.ttsBloc.speak(any())).thenAnswer((_) async {});
            bloc.add(AcrouletteChangeMode(acroulette));
            bloc.add(AcrouletteChangeMode(washingMachine));
            bloc.add(AcrouletteChangeMode(acroulette));
          },
          expect: () => [
                isA<AcrouletteFlowState>().having(
                    (state) => state.flowName, 'flowName', 'ninja side star'),
                // is fired immediately because of the test AcrouletteChangeMode(acroulette)
                isA<AcrouletteFlowState>().having(
                    (state) => state.flowName, 'flowName', isA<String>()),
                isA<AcrouletteCommandRecognizedState>()
                    .having((state) => state.currentFigure, 'currentFigure',
                        'ninja side star')
                    .having((state) => state.nextFigure, 'nextFigure',
                        'reverse bird')
                    .having((state) => state.previousFigure, 'previousFigure',
                        'buddha')
                    .having((state) => state.mode, 'mode', acroulette),
                isA<AcrouletteCommandRecognizedState>()
                    .having((state) => state.currentFigure, 'currentFigure',
                        isA<String>())
                    .having((state) => state.nextFigure, 'nextFigure', '')
                    .having(
                        (state) => state.previousFigure, 'previousFigure', '')
                    .having((state) => state.mode, 'mode', acroulette),
              ]);
    });
  });
}
