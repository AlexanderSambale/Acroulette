import 'dart:io';

import 'package:acroulette/bloc/acroulette/acroulette_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/objectboxstore.dart';
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
    late Store store;
    late ObjectBox objectbox;
    final dir = Directory('acroulette_bloc_testdata_initial');
    setUp(() async {
      if (dir.existsSync()) dir.deleteSync(recursive: true);
      await dir.create();
      store = await openStore(directory: dir.path);
      objectbox = await ObjectBox.create(store);
      acrouletteBloc = AcrouletteBloc(MockFlutterTts(), objectbox);
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
      expect: () =>
          [AcrouletteInitModel(), AcrouletteVoiceRecognitionStartedState()],
    );
  });

  group('acroulette_bloc AcrouletteStart', () {
    late AcrouletteBloc acrouletteBloc;
    late Store store;
    late ObjectBox objectbox;
    final dir = Directory('acroulette_bloc_testdata_start');

    setUp(() async {
      if (dir.existsSync()) dir.deleteSync(recursive: true);
      await dir.create();
      store = await openStore(directory: dir.path);
      objectbox = await ObjectBox.create(store);
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

      acrouletteBloc = AcrouletteBloc(MockFlutterTts(), objectbox);
      acrouletteBloc.add(AcrouletteStart());
    });

    tearDown(() {
      store.close();
      if (dir.existsSync()) dir.deleteSync(recursive: true);
    });

    test('AcrouletteStart', () async {
      expect(acrouletteBloc.state, AcrouletteInitialState());
      expect(acrouletteBloc.voiceRecognitionBloc.state,
          const VoiceRecognitionState(false));
      await Future.delayed(const Duration(seconds: 2), () {});
      expect(acrouletteBloc.voiceRecognitionBloc.state,
          const VoiceRecognitionState(true));
    });
  });
}
