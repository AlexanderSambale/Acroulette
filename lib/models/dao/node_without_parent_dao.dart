import 'package:acroulette/models/relations/node_without_parent.dart';
import 'package:floor/floor.dart';

@dao
abstract class NodeWithoutParentDao {
  @insert
  Future<int> insertObject(NodeWithoutParent nodeNode);

  @delete
  Future<void> removeObject(NodeWithoutParent nodeNode);

  @Query('SELECT * FROM NodeWithoutParent')
  Future<List<NodeWithoutParent>> findAll();
}
