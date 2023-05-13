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

  test('convert Node, which is a category, to String and back', () {
    const String leafLabel = 'leaf';
    AcroNode rootAcroNode = AcroNode(true, "root");
    Node leaf1 = Node.createLeaf(AcroNode(false, "${leafLabel}1"));
    Node leaf2 = Node.createLeaf(AcroNode(false, "${leafLabel}2"));
    Node leaf3 = Node.createLeaf(AcroNode(false, "${leafLabel}3"));
    Node category = Node.createCategory([leaf1, leaf2, leaf3], rootAcroNode);
    category.isExpanded = false;
    String categoryAsJsonString = category.toString();
    Node categoryTransformed = Node.createFromString(categoryAsJsonString);
    expect(category.children.isEmpty, categoryTransformed.children.isEmpty);
    expect(category.children.length, categoryTransformed.children.length);
    expect(category.isLeaf, categoryTransformed.isLeaf);
    expect(category.value.target, categoryTransformed.value.target);
    expect(category.children[2], categoryTransformed.children[2]);
  });

  test('convert Node, which is a leaf, to String and back', () {
    const String leafLabel = 'leaf';
    AcroNode rootAcroNode = AcroNode(false, leafLabel);
    Node leaf = Node.createLeaf(rootAcroNode);
    String leafAsJsonString = leaf.toString();
    Node leafTransformed = Node.createFromString(leafAsJsonString);
    expect(leafTransformed.children.isEmpty, leaf.children.isEmpty);
    expect(leafTransformed.isLeaf, leaf.isLeaf);
    expect(leafTransformed.value.target, leaf.value.target);
    expect(leafTransformed.isExpanded, leaf.isExpanded);
    expect(leafTransformed.label, leaf.label);
  });
}
