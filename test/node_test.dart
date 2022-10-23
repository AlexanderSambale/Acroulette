import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('LeafNode', () {
    Node leaf = Node.createLeaf(AcroNode(false, 'test'));
    expect(leaf.children.isEmpty, equals(true));
    expect(leaf.isLeaf, equals(true));
  });

  test('Category with some posture items', () {
    const String leafLabel = 'leaf';
    Node leaf1 = Node.createLeaf(AcroNode(false, "${leafLabel}1"));
    Node leaf2 = Node.createLeaf(AcroNode(false, "${leafLabel}2"));
    Node leaf3 = Node.createLeaf(AcroNode(false, "${leafLabel}3"));
    AcroNode rootAcroNode = AcroNode(true, "root");
    Node category = Node.createCategory([leaf1, leaf2, leaf3], rootAcroNode);
    category.isExpanded = false;
    expect(category.children.isEmpty, equals(false));
    expect(category.children.length, equals(3));
    expect(category.isLeaf, equals(false));
    expect(category.value.target, equals(rootAcroNode));
    expect(category.children.contains(leaf3), equals(true));
  });
}
