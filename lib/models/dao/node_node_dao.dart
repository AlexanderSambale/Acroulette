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

  @Query('SELECT * FROM NodeNode WHERE parentId = :id')
  Future<List<NodeNode?>> findChildrenByParentId(int id);

  @Query('SELECT * FROM Node WHERE parentId IS NULL')
  Future<List<NodeNode>> findNodesWithoutParent();
}
