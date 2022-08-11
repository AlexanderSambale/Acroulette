import 'dart:collection';

import 'package:objectbox/objectbox.dart';

@Entity()
class SettingsPair {
  int id = 0;

  late String key;
  late String value;

  SettingsPair(this.key, this.value);

  static HashMap<String, String> toMap(List<SettingsPair> pairs) {
    return HashMap.fromIterable(pairs,
        key: (pair) => pair.key, value: (pair) => pair.value);
  }
}
