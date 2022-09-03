import 'dart:collection';

import 'package:acroulette/models/node.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('LeafNode', () {
    Node<int> leaf = Node.createLeaf(null);
    expect(leaf.children.isEmpty, equals(true));
    expect(leaf.isLeaf, equals(true));
  });

  test('Category with some posture items', () {
    const String label = 'category';
    const String leafLabel3 = 'leaf3';
    Node<String> leaf3 = Node.createLeaf(leafLabel3);
    Node<String> category = Node(
        LinkedHashSet<Node<String>>(
            equals: (n0, n1) => n0 == n1, hashCode: (n2) => n2.hashCode),
        false,
        label);
    category.addNode(Node.createLeaf('leaf1'));
    category.addNode(Node.createLeaf('leaf2'));
    category.addNode(leaf3);
    expect(category.children.isEmpty, equals(false));
    expect(category.children.length, equals(3));
    expect(category.isLeaf, equals(false));
    expect(category.value, equals(label));
    expect(category.children.contains(leaf3), equals(true));
  });
}
