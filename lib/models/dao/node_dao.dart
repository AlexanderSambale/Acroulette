import 'package:acroulette/models/entities/node_entity.dart';
import 'package:floor/floor.dart';

const String isLeafKey = "isLeaf";
const String isExpandedKey = "isExpanded";
const String childrenKey = "children";
const String valueKey = "value";

@dao
abstract class NodeDao {
  @Query('SELECT COUNT(*) FROM NodeEntity')
  Future<int?> count();

  @Query('SELECT * FROM NodeEntity')
  Future<List<NodeEntity>> findAll();

  @Query('SELECT * FROM NodeEntity WHERE autoId = :id')
  Future<NodeEntity?> findEntityById(int id);

  Future<List<NodeEntity?>> findAllById(List<int> ids) async {
    List<NodeEntity?> entities = [];
    for (var id in ids) {
      entities.add(await findEntityById(id));
    }
    return entities;
  }

  @Query('DELETE FROM NodeEntity WHERE autoId = :id')
  Future<void> deleteById(int id);

  Future<void> deleteByIds(List<int> ids) async {
    for (var id in ids) {
      await deleteById(id);
    }
  }

  @insert
  Future<int> insertObject(NodeEntity object);

  @insert
  Future<List<int>> insertObjects(List<NodeEntity> objects);

  @delete
  Future<void> removeObject(NodeEntity object);

  @update
  Future<void> updateObject(NodeEntity object);
}
