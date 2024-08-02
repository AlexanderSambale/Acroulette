import 'package:floor/floor.dart';

@Entity(primaryKeys: ['parentId', 'childId'])
class NodeNode {
  final int? parentId;
  final int childId;

  NodeNode(this.parentId, this.childId);
}
