import 'package:acroulette/models/node.dart';

Node createSimpleTree({
  String rootName = 'root',
  String leaf1Name = 'leaf1',
  String leaf2Name = 'leaf2',
  String leaf3Name = 'leaf3',
}) {
  Node leaf1 = Node.createLeaf(label: leaf1Name);
  Node leaf2 = Node.createLeaf(
    isSwitched: false,
    isEnabled: false,
    label: leaf2Name,
  );
  Node leaf3 = Node.createLeaf(label: leaf3Name);
  Node category = Node.optional(
    children: [leaf1, leaf2, leaf3],
    label: rootName,
  );
  return category;
}

Node createComplexTree() {
  Node root = Node.optional(
    children: [
      createSimpleTree(rootName: 'root1'),
      createSimpleTree(rootName: 'root2'),
      createSimpleTree(rootName: 'root3'),
    ],
    label: 'newRoot',
  );
  return root;
}
