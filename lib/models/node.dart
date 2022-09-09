import 'package:acroulette/models/acro_node.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Node {
  int id = 0;

  bool get isLeaf => children.isEmpty;
  ToMany<Node> children = ToMany<Node>();
  ToOne<AcroNode> value = ToOne<AcroNode>();
  bool isExpanded;

  Node(this.children, this.value, {this.isExpanded = true});
  Node.createLeaf(this.value, {this.isExpanded = true});

  addNode(Node node) {
    children.add(node);
  }

  addAll(List<Node> nodes) {
    children.addAll(nodes);
  }

  removeNode(Node node) {
    children.remove(node);
  }
}
