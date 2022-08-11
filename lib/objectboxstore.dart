import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/models/SettingsPair.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  late final Box<SettingsPair> settingsBox;

  ObjectBox._create(this.store) {
    settingsBox = Box<SettingsPair>(store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
    return ObjectBox._create(store);
  }

  String getSettingsPairValueByKey(String key) {
    Query<SettingsPair> keyQuery =
        settingsBox.query(SettingsPair_.key.equals(key)).build();
    SettingsPair? keyQueryFirstValue = keyQuery.findFirst();
    if (keyQueryFirstValue == null) {
      return key;
    } else {
      return keyQueryFirstValue.value;
    }
  }

  void putSettingsPairValueByKey(String key, String value) {
    Query<SettingsPair> keyQuery =
        settingsBox.query(SettingsPair_.key.equals(key)).build();
    SettingsPair? keyQueryFirstValue = keyQuery.findFirst();
    if (keyQueryFirstValue == null) {
      settingsBox.put(SettingsPair(key, value));
    } else {
      keyQueryFirstValue.value = value;
      settingsBox.put(keyQueryFirstValue);
    }
  }
}
