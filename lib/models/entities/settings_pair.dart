import 'dart:collection';

import 'package:acroulette/models/entities/base_entity.dart';
import 'package:floor/floor.dart';

@entity
class SettingsPair extends BaseEntity {
  late String key;
  late String value;

  SettingsPair(this.key, this.value);

  static HashMap<String, String> toMap(List<SettingsPair> pairs) {
    return HashMap.fromIterable(pairs,
        key: (pair) => pair.key, value: (pair) => pair.value);
  }
}
