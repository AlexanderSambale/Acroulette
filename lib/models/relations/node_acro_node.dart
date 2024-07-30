import 'package:floor/floor.dart';

@Entity(primaryKeys: ['nodeId', 'acroNode'])
class NodeAcroNode {
  final int nodeId;
  final int acroNodeId;

  NodeAcroNode(this.nodeId, this.acroNodeId);
}
