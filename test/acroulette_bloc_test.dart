import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../lib/bloc/acroulette/acroulette_bloc.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'acroulette_bloc_test.mocks.dart';

@GenerateMocks([FlutterTts])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('acroulette_bloc initial', () {
    late AcrouletteBloc acrouletteBloc;

    setUp(() {
      acrouletteBloc = AcrouletteBloc(MockFlutterTts());
    });

    test('initial state is AcrouletteInitialState()', () {
      expect(acrouletteBloc.state, AcrouletteInitialState());
    });

    blocTest<AcrouletteBloc, BaseAcrouletteState>(
      'emits [AcrouletteStartState()] when CounterIncrementPressed is added',
      build: () => acrouletteBloc,
      act: (bloc) => bloc.add(AcrouletteStart()),
      expect: () => [AcrouletteStartState()],
    );
  });

  group('acroulette_bloc AcrouletteStart', () {
    late AcrouletteBloc acrouletteBloc;

    setUp(() {
      acrouletteBloc = AcrouletteBloc(MockFlutterTts());
      acrouletteBloc.add(AcrouletteStart());
    });

    test('AcrouletteStart', () {
      expect(acrouletteBloc.state, AcrouletteStartState());
      expect(acrouletteBloc.voiceRecognitionBloc.state,
          VoiceRecognitionState(true));
    });
  });
}
