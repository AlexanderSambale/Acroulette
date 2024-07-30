import 'package:acroulette/models/relations/node_acro_node.dart';
import 'package:floor/floor.dart';

@dao
abstract class NodeAcroNodeDao {
  @insert
  Future<void> insertObject(NodeAcroNode nodeAcroNode);

  @delete
  Future<void> removeObject(NodeAcroNode nodeAcroNode);
}
