import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/entities/settings_pair.dart';
import 'package:acroulette/models/pair.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('settings_pair_dao', () {
    late AppDatabase database;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    });

    tearDown(() async {
      await database.close();
    });

    test('create SettingsPair', () async {
      SettingsPair settingsPair = SettingsPair(null, 'key', 'value');
      await database.settingsPairDao.insertObject(settingsPair);
      SettingsPair? output = await database.settingsPairDao.findEntityById(1);
      expect(output, isNot(null));
    });

    test('create SettingsPair and find by key', () async {
      String key = 'key';
      String value = 'value';
      SettingsPair settingsPair = SettingsPair(null, key, value);
      await database.settingsPairDao.insertObject(settingsPair);
      SettingsPair? output =
          await database.settingsPairDao.findEntityByKey(key);
      expect(output!.value, value);
    });

    test('update SettingsPair', () async {
      String key = 'key';
      String value = 'value';
      String expected = 'expected';
      SettingsPair? settingsPair = SettingsPair(null, key, value);
      await database.settingsPairDao.insertObject(settingsPair);
      settingsPair = await database.settingsPairDao.findEntityByKey(key);
      settingsPair?.value = expected;
      await database.settingsPairDao.updateObject(settingsPair!);
      SettingsPair? output =
          await database.settingsPairDao.findEntityByKey(key);
      expect(output!.value, expected);
    });

    test('set default values with same key_text', () async {
      String key = 'key';
      String key1 = '${key}1';
      String key3 = '${key}3';
      String value = 'value';
      List<Pair> defaultValues = [
        Pair(key1, value),
        Pair(key, value),
        Pair(key, value),
        Pair(key3, value),
      ];
      await database.settingsPairDao.setDefaultValues(defaultValues);
      SettingsPair? defaultValue;
      defaultValue = await database.settingsPairDao.findEntityByKey(key);
      expect(defaultValue, isNotNull);
      defaultValue = await database.settingsPairDao.findEntityByKey(key1);
      expect(key1, isNotNull);
      defaultValue = await database.settingsPairDao.findEntityByKey(key3);
      expect(key3, isNotNull);
    });
  });
}
