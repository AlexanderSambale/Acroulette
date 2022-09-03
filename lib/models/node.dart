import 'dart:collection';

import 'package:objectbox/objectbox.dart';

@Entity()
class Node<T> {
  int id = 0;

  late bool isLeaf;
  final LinkedHashSet<Node<T>> children;
  T? value;

  Node(this.children, this.isLeaf, this.value);
  Node.createLeaf(this.value)
      : isLeaf = true,
        children = LinkedHashSet<Node<T>>(
            equals: (n0, n1) => n0 == n1, hashCode: (n2) => n2.hashCode);

  addNode(Node<T> node) {
    children.add(node);
  }

  addAll(LinkedHashSet<Node<T>> nodes) {
    children.addAll(nodes);
  }

  removeNode(Node<T> node) {
    children.remove(node);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Node<T> &&
          runtimeType == other.runtimeType &&
          isLeaf == other.isLeaf &&
          value == other.value &&
          children == other.children;

  @override
  int get hashCode =>
      Object.hash(isLeaf.hashCode, children.hashCode, value.hashCode);
}
