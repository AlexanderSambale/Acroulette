import 'package:acroulette/models/entities/position.dart';
import 'package:floor/floor.dart';

@dao
abstract class PositionDao {
  @Query('SELECT last_insert_rowid()')
  Future<int?> incrementedId();

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
}
