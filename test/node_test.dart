import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:objectbox/objectbox.dart';

void main() {
  test('LeafNode', () {
    ToOne<AcroNode> acroNode = ToOne<AcroNode>();
    acroNode.target = AcroNode(false, 'test');
    Node leaf = Node.createLeaf(acroNode);
    expect(leaf.children.isEmpty, equals(true));
    expect(leaf.isLeaf, equals(true));
  });

  test('Category with some posture items', () {
    const String leafLabel = 'leaf';
    Node leaf1 = Node.createLeaf(ToOne<AcroNode>());
    leaf1.value.target = AcroNode(false, "${leafLabel}1");
    Node leaf2 = Node.createLeaf(ToOne<AcroNode>());
    leaf2.value.target = AcroNode(false, "${leafLabel}2");
    Node leaf3 = Node.createLeaf(ToOne<AcroNode>());
    leaf3.value.target = AcroNode(false, "${leafLabel}3");
    AcroNode rootAcroNode = AcroNode(true, "root");
    Node category = Node(ToMany<Node>(), ToOne<AcroNode>());
    category.isExpanded = false;
    category.value.target = rootAcroNode;
    category.addNode(leaf1);
    category.addNode(leaf2);
    category.addNode(leaf3);
    expect(category.children.isEmpty, equals(false));
    expect(category.children.length, equals(3));
    expect(category.isLeaf, equals(false));
    expect(category.value.target, equals(rootAcroNode));
    expect(category.children.contains(leaf3), equals(true));
  });
}
