import 'dart:collection';

import 'package:objectbox/objectbox.dart';

@Entity()
class Node<T> {
  int id = 0;

  late bool isLeaf;
  final LinkedHashSet<Node<T>> children;
  T? value;

  T? getValue() {
    return value;
  }

  setValue(T? newValue) {
    value = newValue;
  }

  Node(this.children) {
    if (children.isEmpty) {
      isLeaf = true;
    } else {
      isLeaf = false;
    }
  }

  addNode(Node<T> node) {
    children.add(node);
    isLeaf = false;
  }

  removeNode(Node<T> node) {
    children.remove(node);
    if (children.isEmpty) {
      isLeaf = true;
    }
  }
}
