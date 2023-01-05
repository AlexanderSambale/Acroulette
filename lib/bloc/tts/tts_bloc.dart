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

  String? _language, _engine;
  late bool isCurrentLanguageInstalled = false;

  late final Future<dynamic> languages;
  late final Future<dynamic> engines;
  late final Future<dynamic> defaultEngine;
  late final Future<dynamic> defaultVoice;

  TtsBloc(this.objectbox) : super(TtsIdleState()) {
    on<TtsChangeEvent>((event, emit) {
      emit(TtsChangeState(event.property));
      add(const TtsIdleEvent());
    });
    on<TtsIdleEvent>((event, emit) {
      emit(TtsIdleState());
    });

    flutterTts = FlutterTts();
    _setAwaitOptions();
    volume = double.parse(objectbox.getSettingsPairValueByKey(volumeKey));
    speechRate = double.parse(objectbox.getSettingsPairValueByKey(rateKey));
    pitch = double.parse(objectbox.getSettingsPairValueByKey(pitchKey));
    engine = objectbox.getSettingsPairValueByKey(engineKey);
    language = objectbox.getSettingsPairValueByKey(languageKey);
    languages = _getLanguages();
    engines = _getEngines();
    defaultEngine = _getDefaultEngine();
    defaultVoice = _getDefaultVoice();
  }

  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  double get volume => round(_volume);
  double get speechRate => round(_rate);
  double get pitch => round(_pitch);
  String? get language => _language;
  String? get engine => _engine;
  set volume(double newVolume) => setVolume(newVolume);
  set speechRate(double newRate) => setSpeechRate(newRate);
  set pitch(double newPitch) => setPitch(newPitch);
  set language(String? newLanguage) => setLanguage(newLanguage);
  set engine(String? newLanguage) => setEngine(newLanguage);

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

  Future<void> setLanguage(String? newLanguage) async {
    if (newLanguage != null) {
      _language = newLanguage;
      objectbox.putSettingsPairValueByKey(languageKey, newLanguage);
      await flutterTts.setLanguage(newLanguage);
      if (isAndroid) {
        var isInstalled = await isLanguageInstalled(newLanguage);
        isCurrentLanguageInstalled = (isInstalled as bool);
      }
      add(const TtsChangeEvent(languageKey));
    }
  }

  Future<void> setEngine(String? newEngine) async {
    if (newEngine != null) {
      _engine = newEngine;
      objectbox.putSettingsPairValueByKey(engineKey, newEngine);
      await flutterTts.setEngine(newEngine);
      add(const TtsChangeEvent(engineKey));
    }
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future<dynamic> _getEngines() async => await flutterTts.getEngines;

  Future<dynamic> _getDefaultEngine() async =>
      await flutterTts.getDefaultEngine;

  Future<dynamic> _getDefaultVoice() async => await flutterTts.getDefaultVoice;

  dispose() {
    flutterTts.stop();
  }

  Future<dynamic> isLanguageInstalled(String language) {
    return flutterTts.isLanguageInstalled(language);
  }
}

double round(double value) {
  return (value * 10 + 0.5).truncateToDouble() / 10;
}
