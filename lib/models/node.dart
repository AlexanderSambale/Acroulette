import 'package:acroulette/models/acro_node.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Node {
  int id = 0;

  bool isLeaf;
  ToMany<Node> children = ToMany<Node>();
  ToOne<AcroNode> value = ToOne<AcroNode>();
  bool isExpanded;
  String? get label => value.target?.label;

  Node(this.children, this.value,
      {this.isLeaf = false, this.isExpanded = true});

  Node.createCategory(List<Node> children, AcroNode acroNode,
      {this.isLeaf = false, this.isExpanded = true}) {
    this.children.addAll(children);
    value.target = acroNode;
  }

  Node.createLeaf(acroNode, {this.isLeaf = true, this.isExpanded = true}) {
    value.target = acroNode;
  }

  addNode(Node node) {
    if (isLeaf) Exception('This is a leaf! Nodes cannot be added.');
    children.add(node);
  }

  addAll(List<Node> nodes) {
    if (isLeaf) Exception('This is a leaf! Nodes cannot be added.');
    children.addAll(nodes);
  }

  removeNode(Node node) {
    if (isLeaf) Exception('This is a leaf! Nodes cannot be removed.');
    children.remove(node);
  }
}
