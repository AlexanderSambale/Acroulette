import 'package:acroulette/models/entities/acro_node.dart';
import 'package:floor/floor.dart';

@dao
abstract class AcroNodeDao {
  @Query('SELECT last_insert_rowid()')
  Future<int?> incrementedId();

  @insert
  Future<void> insertObject(AcroNode object);

  @delete
  Future<void> removeObject(AcroNode object);

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
}
