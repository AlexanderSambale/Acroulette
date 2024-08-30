import 'package:acroulette/models/node.dart';

Node createSimpleTreeEnabled({
  String rootName = 'root',
  String leaf1Name = 'leaf1',
  String leaf2Name = 'leaf2',
  String leaf3Name = 'leaf3',
}) {
  Node leaf1 = Node.createLeaf(
    label: leaf1Name,
  );
  Node leaf2 = Node.createLeaf(
    isSwitched: false,
    isEnabled: false,
    label: leaf2Name,
  );
  Node leaf3 = Node.createLeaf(
    label: leaf3Name,
  );
  Node category = Node.optional(
    children: [leaf1, leaf2, leaf3],
    label: rootName,
  );
  return category;
}

Node createSimpleTreeDisabled({
  String rootName = 'root',
  String leaf1Name = 'leaf1',
  String leaf2Name = 'leaf2',
  String leaf3Name = 'leaf3',
}) {
  Node leaf1 = Node.createLeaf(
    label: leaf1Name,
    isEnabled: false,
  );
  Node leaf2 = Node.createLeaf(
    isSwitched: false,
    isEnabled: false,
    label: leaf2Name,
  );
  Node leaf3 = Node.createLeaf(
    label: leaf3Name,
    isEnabled: false,
  );
  Node category = Node.optional(
    children: [leaf1, leaf2, leaf3],
    label: rootName,
    isEnabled: false,
    isSwitched: false,
  );
  return category;
}

Node createComplexTree() {
  Node root = Node.optional(
    children: [
      createSimpleTreeEnabled(rootName: 'root1'),
      createSimpleTreeDisabled(rootName: 'root2'),
      createSimpleTreeEnabled(rootName: 'root3'),
    ],
    label: 'newRoot',
  );
  return root;
}
