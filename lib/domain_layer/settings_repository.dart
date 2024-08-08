import 'package:acroulette/constants/model.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/exceptions/pair_value_exception.dart';
import 'package:acroulette/models/entities/settings_pair.dart';
import 'package:acroulette/models/pair.dart';
import 'package:acroulette/storage_provider.dart';

class SettingsRepository {
  final StorageProvider storageProvider;
  late List<SettingsPair> settings = [];

  SettingsRepository(this.storageProvider);

  Future<void> initialize() async {
    settings = await storageProvider.settingsBox.findAll();

    List<Pair> defaultValues = [
      Pair(appMode, acroulette),
      // voice recognition
      Pair(newPosition, newPosition),
      Pair(nextPosition, nextPosition),
      Pair(previousPosition, previousPosition),
      Pair(currentPosition, currentPosition),

      // text to speech
      Pair(rateKey, "0.5"),
      Pair(pitchKey, "0.5"),
      Pair(volumeKey, "0.5"),
      Pair(languageKey, "en-US"),
      Pair(engineKey, "com.google.android.tts"),
      Pair(playingKey, "false"),
      Pair(flowIndex, "1"),
    ];

    await setDefaultValues(defaultValues);
  }

  void setDefaultValue(String key, String value) async {
    try {
      await getSettingsPairValueByKey(key);
    } on PairValueException {
      await putSettingsPairValueByKey(key, value);
    }
  }

  Future<void> setDefaultValues(List<Pair> values) async {
    await storageProvider.settingsBox.setDefaultValues(values);
  }

  Future<String> getSettingsPairValueByKey(String key) async {
    SettingsPair? keyQueryFirstValue =
        await storageProvider.settingsBox.findEntityByKey(key);
    if (keyQueryFirstValue == null) {
      throw PairValueException(
          "There is no value for the key $key in settings yet!");
    }
    return keyQueryFirstValue.value;
  }

  Future<void> putSettingsPairValueByKey(String key, String value) async {
    SettingsPair? keyQueryFirstValue =
        await storageProvider.settingsBox.findEntityByKey(key);
    if (keyQueryFirstValue == null) {
      await storageProvider.settingsBox
          .insertObject(SettingsPair(null, key, value));
    } else {
      if (keyQueryFirstValue.value == value) return;
      keyQueryFirstValue.value = value;
      await storageProvider.settingsBox.updateObject(keyQueryFirstValue);
    }
    settings = await storageProvider.settingsBox.findAll();
  }
}
