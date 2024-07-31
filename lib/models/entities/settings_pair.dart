import 'dart:collection';

import 'package:acroulette/models/entities/base_entity.dart';
import 'package:floor/floor.dart';

@entity
class SettingsPair extends BaseEntity {
  @ColumnInfo(name: 'key_text')
  late String key;
  late String value;

  SettingsPair(super.autoId, this.key, this.value);

  factory SettingsPair.optional({
    int? autoId,
    String? key,
    String? value,
  }) =>
      SettingsPair(autoId, key ?? '', value ?? '');

  static HashMap<String, String> toMap(List<SettingsPair> pairs) {
    return HashMap.fromIterable(pairs,
        key: (pair) => pair.key, value: (pair) => pair.value);
  }
}
