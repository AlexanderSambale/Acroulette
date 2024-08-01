import 'package:acroulette/models/entities/acro_node.dart';
import 'package:floor/floor.dart';

@dao
abstract class AcroNodeDao {
  @Query('SELECT last_insert_rowid()')
  Future<int?> incrementedId();

  @Query('SELECT COUNT(*) FROM AcroNode')
  Future<int?> count();

  @insert
  Future<void> insertObject(AcroNode object);

  @delete
  Future<void> removeObject(AcroNode object);

  @Query('DELETE FROM AcroNode WHERE autoId = :id')
  Future<void> removeById(int id);

  Future<int> remove(AcroNode object) async {
    await removeObject(object);
    return object.id;
  }

  Future<int> put(AcroNode object) async {
    await insertObject(object);
    int? id = await incrementedId();
    if (id == null) {
      throw Exception('Id is null after put');
    }
    return id;
  }

  Future<List<int>> putAll(List<AcroNode> objects) async {
    List<int> ids = [];
    for (var object in objects) {
      ids.add(await put(object));
    }
    return ids;
  }

  @Query('VACUUM AcroNode')
  Future<void> vacuum();

  @Query('DELETE FROM AcroNode')
  Future<void> deleteAll();

  Future<void> deleteByIds(List<int> ids) async {
    for (var id in ids) {
      await removeById(id);
    }
    await vacuum();
  }

  Future<void> clear() async {
    await deleteAll();
    await vacuum();
  }

  @Query('SELECT * FROM AcroNode')
  Future<List<AcroNode?>> findAll();
}
