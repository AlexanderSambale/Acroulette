import 'package:acroulette/models/relations/node_node.dart';
import 'package:floor/floor.dart';

@dao
abstract class NodeNodeDao {
  @insert
  Future<void> insertObject(NodeNode object);

  @insert
  Future<void> insertObjects(List<NodeNode> objects);

  @delete
  Future<void> removeObject(NodeNode nodeNode);

  @Query('SELECT * FROM NodeNode WHERE childId = :id')
  Future<List<NodeNode>> findByChildId(int id);

  @Query('DELETE FROM NodeNode WHERE childId = :id')
  Future<void> deleteByChildId(int id);

  @Query('DELETE FROM NodeNode WHERE parentId = :id')
  Future<void> deleteByParentId(int id);

  @Query('SELECT * FROM NodeNode WHERE parentId = :id')
  Future<List<NodeNode>> findByParentId(int id);

  Future<void> deleteByParentIds(List<int> ids) async {
    for (var id in ids) {
      await deleteByParentId(id);
    }
  }
}
