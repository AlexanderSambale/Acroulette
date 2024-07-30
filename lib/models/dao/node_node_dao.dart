import 'package:acroulette/models/relations/node_node.dart';
import 'package:floor/floor.dart';

@dao
abstract class NodeNodeDao {
  @insert
  Future<void> insertObject(NodeNode nodeNode);

  @delete
  Future<void> removeObject(NodeNode nodeNode);
}
