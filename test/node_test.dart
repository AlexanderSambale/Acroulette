import 'package:acroulette/models/node.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('LeafNode', () {
    Node leaf = Node.createLeaf(label: 'test');
    expect(leaf.children.isEmpty, equals(true));
    expect(leaf.isLeaf, equals(true));
  });

  test('Category with some posture items', () {
    const String leafLabel = 'leaf';
    Node leaf1 = Node.createLeaf(label: "${leafLabel}1");
    Node leaf2 = Node.createLeaf(label: "${leafLabel}2");
    Node leaf3 = Node.createLeaf(label: "${leafLabel}3");
    String label = "root";
    Node category = Node.optional(
        children: [leaf1, leaf2, leaf3], isLeaf: false, label: label);
    category.isExpanded = false;
    expect(category.children.isEmpty, equals(false));
    expect(category.children.length, equals(3));
    expect(category.isLeaf, equals(false));
    expect(category.label, equals(label));
    expect(category.children.contains(leaf3), equals(true));
  });

  test('convert Node, which is a category, to String and back', () {
    const String leafLabel = 'leaf';
    Node leaf1 = Node.createLeaf(label: "${leafLabel}1");
    Node leaf2 = Node.createLeaf(label: "${leafLabel}2");
    Node leaf3 = Node.createLeaf(label: "${leafLabel}3");
    String label = "root";
    Node category = Node.optional(
      children: [leaf1, leaf2, leaf3],
      isLeaf: false,
      label: label,
      isExpanded: false,
    );
    String categoryAsJsonString = category.toString();
    Node categoryTransformed = Node.createFromString(categoryAsJsonString)[0];
    expect(category.children.isEmpty, categoryTransformed.children.isEmpty);
    expect(category.children.length, categoryTransformed.children.length);
    expect(category.isLeaf, categoryTransformed.isLeaf);
    expect(category.label, categoryTransformed.label);
    expect(
      category.children.elementAt(2),
      categoryTransformed.children.elementAt(2),
    );
  });

  test('convert Node, which is a leaf, to String and back', () {
    const String leafLabel = 'leaf';
    Node leaf = Node.createLeaf(label: leafLabel);
    String leafAsJsonString = leaf.toString();
    Node leafTransformed = Node.createFromString(leafAsJsonString)[0];
    expect(leafTransformed.children.isEmpty, leaf.children.isEmpty);
    expect(leafTransformed.isLeaf, leaf.isLeaf);
    expect(leafTransformed.label, leaf.label);
    expect(leafTransformed.isExpanded, leaf.isExpanded);
    expect(leafTransformed.label, leaf.label);
  });
}
