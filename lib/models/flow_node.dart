import 'package:objectbox/objectbox.dart';

@Entity()
class FlowNode {
  int id = 0;

  String name;
  final List<String> positions;
  bool isExpanded;

  FlowNode(this.name, this.positions, {this.isExpanded = true});
}
