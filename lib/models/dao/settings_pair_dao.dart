import 'package:acroulette/models/entities/settings_pair.dart';
import 'package:floor/floor.dart';

@dao
abstract class SettingsPairDao {
  @Query('SELECT last_insert_rowid()')
  Future<int?> incrementedId();

  @insert
  Future<void> insertObject(SettingsPair object);

  @delete
  Future<void> removeObject(SettingsPair object);

  @Query('SELECT * FROM SettingsPair WHERE key_text = :key')
  Future<SettingsPair?> findEntityByKey(String key);

  @Query('SELECT * FROM SettingsPair WHERE autoId = :id')
  Future<SettingsPair?> findEntityById(int id);

  @update
  Future<void> updateObject(SettingsPair settingsPair);

  Future<int> remove(SettingsPair object) async {
    await removeObject(object);
    return object.id;
  }

  Future<int> put(SettingsPair object) async {
    await insertObject(object);
    int? id = await incrementedId();
    if (id == null) {
      throw Exception('Id is null after put');
    }
    return id;
  }

  Future<List<int>> putAll(List<SettingsPair> objects) async {
    List<int> ids = [];
    for (var object in objects) {
      ids.add(await put(object));
    }
    return ids;
  }
}
