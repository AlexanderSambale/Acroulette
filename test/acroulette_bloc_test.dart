import 'package:acroulette/bloc/acroulette/acroulette_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:mocktail/mocktail.dart';

class MockFlutterTts extends Mock implements FlutterTts {}

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
      'emits [AcrouletteInitModel()] when AcrouletteStart is added',
      build: () => acrouletteBloc,
      act: (bloc) => bloc.add(AcrouletteStart()),
      expect: () => [AcrouletteInitModel()],
    );
  });

  group('acroulette_bloc AcrouletteStart', () {
    late AcrouletteBloc acrouletteBloc;

    setUp(() {
      const MethodChannel('vosk_flutter_plugin')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'onPartial':
            return Stream.fromIterable(["{text: 'next position'}"]);
          case 'initModel':
          case 'start':
          case 'stop':
          default:
            return 'OK';
        }
      });

      acrouletteBloc = AcrouletteBloc(MockFlutterTts());
      acrouletteBloc.add(AcrouletteStart());
    });

    test('AcrouletteStart', () async {
      expect(acrouletteBloc.state, AcrouletteInitModel());
      expect(acrouletteBloc.voiceRecognitionBloc.state,
          const VoiceRecognitionState(false));
      await Future.delayed(const Duration(seconds: 2), () {});
      expect(acrouletteBloc.voiceRecognitionBloc.state,
          const VoiceRecognitionState(true));
    });
  });
}
