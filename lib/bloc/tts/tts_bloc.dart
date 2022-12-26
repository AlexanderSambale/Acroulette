import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

part 'tts_event.dart';
part 'tts_state.dart';

class TtsBloc extends Bloc<TtsEvent, TtsState> {
  late FlutterTts flutterTts;
  late ObjectBox objectbox;

  late double _volume, _rate, _pitch;

  String? language;
  String? engine;
  late bool isCurrentLanguageInstalled = false;

  late final Future<dynamic> languages;
  late final Future<dynamic> engines;
  late final Future<dynamic> defaultEngine;
  late final Future<dynamic> defaultVoice;

  TtsBloc(this.objectbox) : super(TtsIdleState()) {
    _volume = double.parse(objectbox.getSettingsPairValueByKey(volumeKey));
    _rate = double.parse(objectbox.getSettingsPairValueByKey(rateKey));
    _pitch = double.parse(objectbox.getSettingsPairValueByKey(pitchKey));
    initTts();
    languages = _getLanguages();
    engines = _getEngines();
    defaultEngine = _getDefaultEngine();
    defaultVoice = _getDefaultVoice();

    on<TtsChangeEvent>((event, emit) {
      emit(TtsChangeState());
      add(const TtsIdleEvent());
    });
    on<TtsIdleEvent>((event, emit) {
      emit(TtsIdleState());
    });
  }

  initTts() {
    flutterTts = FlutterTts();
    _setAwaitOptions();
  }

  double get volume => round(_volume);
  double get speechRate => round(_rate);
  double get pitch => round(_pitch);
  set volume(double newVolume) => setVolume(newVolume);
  set speechRate(double newRate) => setSpeechRate(newRate);
  set pitch(double newPitch) => setPitch(newPitch);
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> setVolume(double volume) async {
    _volume = volume;
    add(const TtsChangeEvent(volumeKey));
    objectbox.putSettingsPairValueByKey(volumeKey, volume.toString());
    await flutterTts.setVolume(volume);
  }

  Future<void> setSpeechRate(double rate) async {
    _rate = rate;
    add(const TtsChangeEvent(rateKey));
    objectbox.putSettingsPairValueByKey(rateKey, rate.toString());
    await flutterTts.setSpeechRate(rate);
  }

  Future<void> setPitch(double pitch) async {
    _pitch = pitch;
    add(const TtsChangeEvent(pitchKey));
    objectbox.putSettingsPairValueByKey(pitchKey, pitch.toString());
    await flutterTts.setPitch(pitch);
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future<dynamic> _getEngines() async => await flutterTts.getEngines;

  Future<dynamic> _getDefaultEngine() async =>
      await flutterTts.getDefaultEngine;

  Future _getDefaultVoice() async => await flutterTts.getDefaultVoice;

  dispose() {
    flutterTts.stop();
  }

  isLanguageInstalled(String language) {}
}

double round(double value) {
  return (value * 10 + 0.5).truncateToDouble() / 10;
}
