import 'dart:collection';
import 'package:isar/isar.dart';

part 'settings_pair.g.dart';

@collection
class SettingsPair {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  late String key;
  late String value;

  SettingsPair(this.key, this.value);

  static HashMap<String, String> toMap(List<SettingsPair> pairs) {
    return HashMap.fromIterable(pairs,
        key: (pair) => pair.key, value: (pair) => pair.value);
  }
}
