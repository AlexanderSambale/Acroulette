import 'dart:io';

import 'package:acroulette/bloc/acroulette/acroulette_bloc.dart';
import 'package:acroulette/bloc/transition/transition_bloc.dart';
import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:mocktail/mocktail.dart';

class MockFlutterTts extends Mock implements TtsBloc {}

class MockVoiceRecognitionBloc extends Mock implements VoiceRecognitionBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('acroulette bloc', () {
    late AcrouletteBloc acrouletteBloc;
    late Store store;
    late ObjectBox objectbox;
    late TtsBloc ttsBloc;
    late VoiceRecognitionBloc voiceRecognitionBloc;

    final dir = Directory('acroulette_bloc_testdata_initial');
    setUp(() async {
      if (dir.existsSync()) dir.deleteSync(recursive: true);
      await dir.create();
      store = await openStore(directory: dir.path);
      objectbox = await ObjectBox.create(store);
      ttsBloc = MockFlutterTts();
      voiceRecognitionBloc = MockVoiceRecognitionBloc();
      when(() => voiceRecognitionBloc.isDisabled).thenReturn(false);
      when(() => ttsBloc.notAvailable).thenReturn(true);
      acrouletteBloc = AcrouletteBloc(ttsBloc, objectbox, voiceRecognitionBloc);
    });

    tearDown(() {
      store.close();
      if (dir.existsSync()) dir.deleteSync(recursive: true);
      acrouletteBloc.close();
    });

    test('initial state is AcrouletteInitialState()', () {
      expect(acrouletteBloc.state, AcrouletteInitialState());
    });

    blocTest<AcrouletteBloc, BaseAcrouletteState>(
        'emits [AcrouletteInitModel()] when AcrouletteStart is added',
        build: () => acrouletteBloc,
        act: (bloc) => bloc.add(AcrouletteStart()),
        expect: () => [AcrouletteInitModel()],
        verify: (bloc) =>
            expect(objectbox.getSettingsPairValueByKey(playingKey), "true"));

    blocTest<AcrouletteBloc, BaseAcrouletteState>(
        'emits [AcrouletteModelInitiatedState()] when AcrouletteStop is added',
        build: () => acrouletteBloc,
        act: (bloc) => bloc.add(AcrouletteStop()),
        expect: () => [AcrouletteModelInitiatedState()],
        verify: (bloc) =>
            expect(objectbox.getSettingsPairValueByKey(playingKey), "false"));

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
          act: (bloc) {
            when(() => bloc.voiceRecognitionBloc.state)
                .thenReturn(const VoiceRecognitionState(true));
            when(() => bloc.ttsBloc.speak(any())).thenAnswer((_) async {});
            bloc.transitionBloc
                .add(InitFlowTransitionEvent(objectbox.flowPositions()));
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
                    .having(
                        (state) => state.previousFigure, 'previousFigure', ''),
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
                    .having(
                        (state) => state.previousFigure, 'previousFigure', ''),
              ]);
    });
  });
}
