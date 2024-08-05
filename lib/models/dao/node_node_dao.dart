import 'package:acroulette/models/relations/node_node.dart';
import 'package:floor/floor.dart';

@dao
abstract class NodeNodeDao {
  @insert
  Future<void> insertObject(NodeNode nodeNode);

  @delete
  Future<void> removeObject(NodeNode nodeNode);

  @Query('SELECT * FROM NodeNode WHERE childId = :id')
  Future<NodeNode?> findParentByChildId(int id);

  @Query('DELETE * FROM NodeNode WHERE childId = :id')
  Future<void> deleteByChildId(int id);

  @Query('DELETE * FROM NodeNode WHERE parentId = :id')
  Future<void> deleteByParentId(int id);

  @Query('SELECT * FROM NodeNode WHERE parentId = :id')
  Future<List<NodeNode>> findChildrenByParentId(int id);

  Future<void> deleteByParentIds(List<int> ids) async {
    for (var id in ids) {
      await deleteByParentId(id);
    }
  }
}
