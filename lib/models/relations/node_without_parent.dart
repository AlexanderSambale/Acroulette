import 'package:floor/floor.dart';

@Entity()
class NodeWithoutParent {
  @PrimaryKey()
  final int nodeId;

  NodeWithoutParent(this.nodeId);
}
