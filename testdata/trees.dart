import 'package:acroulette/models/node.dart';

Node createSimpleTreeSwitchedOn({
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

Node createSimpleTreeSwitchedOff({
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
    isSwitched: false,
  );
  return category;
}

Node createComplexTreeSwitchedOn() {
  Node root = Node.optional(
    children: [
      createSimpleTreeSwitchedOn(rootName: 'root1'),
      createSimpleTreeSwitchedOff(rootName: 'root2'),
      createSimpleTreeSwitchedOn(rootName: 'root3'),
    ],
    label: 'newRoot',
  );
  return root;
}

Node createComplexTreeSwitchedOff({bool childrenSwitched = false}) {
  Node root;
  String leaf1Name = 'leaf1';
  String leaf2Name = 'leaf2';
  String leaf3Name = 'leaf3';
  if (childrenSwitched) {
    root = Node.optional(
      children: [
        Node.optional(
          children: [
            Node.optional(
              label: leaf1Name,
              isEnabled: false,
            ),
            Node.optional(
              label: leaf2Name,
              isEnabled: false,
            ),
            Node.optional(
              label: leaf3Name,
              isEnabled: false,
            ),
          ],
          isEnabled: false,
          label: 'root1',
          isSwitched: false,
        ),
        Node.optional(
          children: [
            Node.optional(
              label: leaf1Name,
              isEnabled: false,
            ),
            Node.optional(
              label: leaf2Name,
              isEnabled: false,
            ),
            Node.optional(
              label: leaf3Name,
              isEnabled: false,
            ),
          ],
          isEnabled: false,
          label: 'root3',
          isSwitched: false,
        ),
        Node.optional(
          children: [
            Node.optional(
              label: leaf1Name,
              isEnabled: false,
            ),
            Node.optional(
              label: leaf2Name,
              isEnabled: false,
            ),
            Node.optional(
              label: leaf3Name,
              isEnabled: false,
            ),
          ],
          isEnabled: false,
          isSwitched: false,
          label: 'root2',
        ),
      ],
      label: 'root',
      isSwitched: false,
    );
  } else {
    // one child is switched off
    root = Node.optional(
      children: [
        Node.optional(
          children: [
            Node.optional(
              label: leaf1Name,
              isEnabled: false,
            ),
            Node.optional(
              label: leaf2Name,
              isEnabled: false,
            ),
            Node.optional(
              label: leaf3Name,
              isEnabled: false,
            ),
          ],
          isEnabled: false,
          label: 'root1',
        ),
        Node.optional(
          children: [
            Node.optional(
              label: leaf1Name,
              isEnabled: false,
            ),
            Node.optional(
              label: leaf2Name,
              isEnabled: false,
            ),
            Node.optional(
              label: leaf3Name,
              isEnabled: false,
            ),
          ],
          isEnabled: false,
          label: 'root3',
        ),
        Node.optional(
          children: [
            Node.optional(
              label: leaf1Name,
              isEnabled: false,
            ),
            Node.optional(
              label: leaf2Name,
              isEnabled: false,
            ),
            Node.optional(
              label: leaf3Name,
              isEnabled: false,
            ),
          ],
          isEnabled: false,
          isSwitched: false,
          label: 'root2',
        ),
      ],
      label: 'root',
      isSwitched: false,
    );
  }
  return root;
}
