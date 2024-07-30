import 'package:acroulette/models/entities/node_entity.dart';
import 'package:floor/floor.dart';

const String isLeafKey = "isLeaf";
const String isExpandedKey = "isExpanded";
const String childrenKey = "children";
const String valueKey = "value";

@dao
abstract class NodeDao {
  @Query('SELECT last_insert_rowid()')
  Future<int?> incrementedId();

  @insert
  Future<void> insertObject(NodeEntity object);

  @delete
  Future<void> removeObject(NodeEntity object);

  Future<int> remove(NodeEntity object) async {
    await removeObject(object);
    return object.id;
  }

  Future<int> put(NodeEntity object) async {
    await insertObject(object);
    int? id = await incrementedId();
    if (id == null) {
      throw Exception('Id is null after put');
    }
    return id;
  }

  Future<List<int>> putAll(List<NodeEntity> objects) async {
    List<int> ids = [];
    for (var object in objects) {
      ids.add(await put(object));
    }
    return ids;
  }
}
