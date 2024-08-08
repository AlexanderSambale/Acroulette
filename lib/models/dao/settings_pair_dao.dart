import 'package:acroulette/models/entities/settings_pair.dart';
import 'package:acroulette/models/pair.dart';
import 'package:floor/floor.dart';

@dao
abstract class SettingsPairDao {
  @insert
  Future<int> insertObject(SettingsPair object);

  @insert
  Future<List<int>> insertObjects(List<SettingsPair> objects);

  @delete
  Future<void> removeObject(SettingsPair object);

  @Query('SELECT * FROM SettingsPair WHERE key_text = :key')
  Future<SettingsPair?> findEntityByKey(String key);

  @Query('SELECT * FROM SettingsPair WHERE autoId = :id')
  Future<SettingsPair?> findEntityById(int id);

  @Query('SELECT * FROM SettingsPair')
  Future<List<SettingsPair>> findAll();

  @update
  Future<void> updateObject(SettingsPair settingsPair);

  Future<int> remove(SettingsPair object) async {
    await removeObject(object);
    return object.id;
  }

  @transaction
  Future<void> setDefaultValues(List<Pair> defaultValues) async {
    for (var defaultValue in defaultValues) {
      try {
        await insertObject(
          SettingsPair(
            null,
            defaultValue.first,
            defaultValue.second,
          ),
        );
      } catch (e) {
        // ignore if the value already exists
      }
    }
  }
}
