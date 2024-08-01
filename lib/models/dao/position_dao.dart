import 'package:acroulette/models/entities/position.dart';
import 'package:floor/floor.dart';

@dao
abstract class PositionDao {
  @Query('SELECT last_insert_rowid()')
  Future<int?> incrementedId();

  @Query('SELECT COUNT(*) FROM Position')
  Future<int?> count();

  @insert
  Future<void> insertObject(Position object);

  @delete
  Future<void> removeObject(Position object);

  Future<int> remove(Position object) async {
    await removeObject(object);
    return object.id;
  }

  Future<int> put(Position object) async {
    await insertObject(object);
    int? id = await incrementedId();
    if (id == null) {
      throw Exception('Id is null after put');
    }
    return id;
  }

  Future<List<int>> putAll(List<Position> objects) async {
    List<int> ids = [];
    for (var object in objects) {
      ids.add(await put(object));
    }
    return ids;
  }

  @Query('VACUUM Position')
  Future<void> vacuum();

  @Query('DELETE FROM Position')
  Future<void> deleteAll();

  Future<void> clear() async {
    await deleteAll();
    await vacuum();
  }

  @Query('SELECT * FROM Position WHERE name = :name')
  Future<Position?> findByName(String name);

  @Query('SELECT * FROM Position')
  Future<List<Position?>> findAll();
}
