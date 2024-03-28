import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/db_controller.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

part 'tts_event.dart';
part 'tts_state.dart';

class TtsBloc extends Bloc<TtsEvent, TtsState> {
  late FlutterTts flutterTts;
  late DBController dbController;
  bool notAvailable = true;

  // initialized so that we can check in the setter
  double _volume = 0.0, _rate = 0.0, _pitch = 0.0;

  String? _language, _engine;
  late bool isCurrentLanguageInstalled = false;

  late final Future<dynamic> languages;
  late final Future<dynamic> engines;
  late final Future<dynamic> defaultEngine;
  late final Future<dynamic> defaultVoice;

  TtsBloc(this.dbController) : super(TtsIdleState()) {
    on<TtsChangeEvent>((event, emit) {
      emit(TtsChangeState(event.property));
      add(const TtsIdleEvent());
    });
    on<TtsIdleEvent>((event, emit) {
      emit(TtsIdleState());
    });

    flutterTts = FlutterTts();
    init(dbController).then((value) => notAvailable = false);
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

  Future init(DBController dbController) async {
    try {
      await _setAwaitOptions();
      volume =
          double.parse(await dbController.getSettingsPairValueByKey(volumeKey));
      speechRate =
          double.parse(await dbController.getSettingsPairValueByKey(rateKey));
      pitch =
          double.parse(await dbController.getSettingsPairValueByKey(pitchKey));
      _language = await dbController.getSettingsPairValueByKey(languageKey);
      engine = await dbController.getSettingsPairValueByKey(engineKey);
      languages = _getLanguages();
      engines = _getEngines();
      defaultEngine = _getDefaultEngine();
      defaultVoice = _getDefaultVoice();
    } on Exception catch (e) {
      return Future.error(e, StackTrace.current);
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> setVolume(double newVolume) async {
    if (_volume == newVolume) return;
    _volume = newVolume;
    add(const TtsChangeEvent(volumeKey));
    dbController.putSettingsPairValueByKey(volumeKey, _volume.toString());
    await flutterTts.setVolume(_volume);
  }

  Future<void> setSpeechRate(double newRate) async {
    if (_rate == newRate) return;
    _rate = newRate;
    add(const TtsChangeEvent(rateKey));
    dbController.putSettingsPairValueByKey(rateKey, _rate.toString());
    await flutterTts.setSpeechRate(_rate);
  }

  Future<void> setPitch(double newPitch) async {
    if (_pitch == newPitch) return;
    _pitch = newPitch;
    add(const TtsChangeEvent(pitchKey));
    dbController.putSettingsPairValueByKey(pitchKey, _pitch.toString());
    await flutterTts.setPitch(_pitch);
  }

  Future<void> setLanguage(String? newLanguage) async {
    if (newLanguage == null || _language == newLanguage) return;
    _language = newLanguage;
    dbController.putSettingsPairValueByKey(languageKey, newLanguage);
    if (_engine == null) return;
    setLanguageShortened(newLanguage);
  }

  Future<void> setLanguageShortened(String newLanguage) async {
    await flutterTts.setLanguage(newLanguage);
    if (isAndroid) {
      var isInstalled = await isLanguageInstalled(newLanguage);
      isCurrentLanguageInstalled = (isInstalled as bool);
    }
    add(const TtsChangeEvent(languageKey));
  }

  Future<void> setEngine(String? newEngine) async {
    if (newEngine == null || _engine == newEngine) return;
    _engine = newEngine;
    dbController.putSettingsPairValueByKey(engineKey, newEngine);
    await flutterTts.setEngine(newEngine);
    await setLanguageShortened(_language!); // should implicitly be not null
    add(const TtsChangeEvent(engineKey));
  }

  Future<void> speak(String text) async {
    if (notAvailable) return;
    await flutterTts.speak(text);
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future<dynamic> _getEngines() async => await flutterTts.getEngines;

  Future<dynamic> _getDefaultEngine() async =>
      await flutterTts.getDefaultEngine;

  Future<dynamic> _getDefaultVoice() async => await flutterTts.getDefaultVoice;

  @override
  Future<void> close() async {
    await flutterTts.stop();
    return super.close();
  }

  Future<dynamic> isLanguageInstalled(String language) {
    return flutterTts.isLanguageInstalled(language);
  }
}

double round(double value) {
  return (value * 10 + 0.5).truncateToDouble() / 10;
}
