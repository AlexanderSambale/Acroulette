import 'dart:io';

import 'package:acroulette/bloc/position_administration/position_administration_bloc.dart';
import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:flutter_test/flutter_test.dart';

Node createSimpleTree(
    {String rootName = 'root',
    String leaf1Name = 'leaf1',
    String leaf2Name = 'leaf2',
    String leaf3Name = 'leaf3'}) {
  Node leaf1 = Node.createLeaf(AcroNode(true, leaf1Name));
  Node leaf2 = Node.createLeaf(AcroNode(false, leaf2Name));
  Node leaf3 = Node.createLeaf(AcroNode(true, leaf3Name));
  Node category =
      Node.createCategory([leaf1, leaf2, leaf3], AcroNode(true, rootName));
  return category;
}

Node createComplexTree() {
  Node root = Node.createCategory([
    createSimpleTree(rootName: 'root1'),
    createSimpleTree(rootName: 'root2'),
    createSimpleTree(rootName: 'root3')
  ], AcroNode(true, 'root'));
  return root;
}

extension ToManyExtension on ToMany<Node> {
  bool containsElementWithId(int id) {
    int length = this.length;
    for (int i = 0; i < length; i++) {
      if (this[i].id == id) return true;
      if (length != this.length) {
        throw ConcurrentModificationError(this);
      }
    }
    return false;
  }

  bool containsElementWithLabel(String label) {
    int length = this.length;
    for (int i = 0; i < length; i++) {
      if (this[i].label! == label) return true;
      if (length != this.length) {
        throw ConcurrentModificationError(this);
      }
    }
    return false;
  }
}

void main() {
  late Store store;
  late ObjectBox objectbox;
  final dir = Directory('testdata');

  setUp(() async {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
    await dir.create();
    store = await openStore(directory: dir.path);
    objectbox = await ObjectBox.create(store);
  });

  tearDown(() {
    store.close();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  group('onDeleteClick', () {
    test('delete leaf', () async {
      PositionAdministrationBloc bloc = PositionAdministrationBloc(objectbox);
      Node child = objectbox.nodeBox.getAll().last;
      Node parent = objectbox.findParent(child);
      expect(parent.children.containsElementWithId(child.id), true);
      int length = parent.children.length;
      expect(
          objectbox.positionBox
              .query(Position_.name.equals(child.label!))
              .build()
              .find()
              .isEmpty,
          false);
      bloc.onDeleteClick(child);
      expect(
          objectbox.positionBox
              .query(Position_.name.equals(child.label!))
              .build()
              .find()
              .isEmpty,
          true);
      parent = objectbox.nodeBox.get(parent.id)!;
      expect(parent.children.containsElementWithId(child.id), false);
      expect(parent.children.length + 1, length);
    });

    test('delete node with children', () async {
      PositionAdministrationBloc bloc = PositionAdministrationBloc(objectbox);
      int numberOfNodesBefore = objectbox.nodeBox.count();
      int numberOfAcroNodesBefore = objectbox.acroNodeBox.count();
      Node root = objectbox.findRoot();
      Node complexTree = createComplexTree();
      root.children.add(complexTree);
      List<Node> nodes = objectbox.getAllChildrenRecursive(complexTree)
        ..add(complexTree)
        ..add(root);
      List<AcroNode> acroNodes =
          nodes.map<AcroNode>((element) => element.value.target!).toList();
      objectbox.putManyAcroNodes(acroNodes);
      objectbox.putManyNodes(nodes);
      int numberOfNodesAfterAdding = objectbox.nodeBox.count();
      int numberOfAcroNodesAfterAdding = objectbox.acroNodeBox.count();
      expect(numberOfNodesBefore, isNot(equals(numberOfNodesAfterAdding)));
      expect(
          numberOfAcroNodesBefore, isNot(equals(numberOfAcroNodesAfterAdding)));
      bloc.onDeleteClick(complexTree);
      int numberOfNodesAfterDeleting = objectbox.nodeBox.count();
      int numberOfAcroNodesAfterDeleting = objectbox.acroNodeBox.count();
      expect(numberOfNodesBefore, numberOfNodesAfterDeleting);
      expect(numberOfAcroNodesBefore, numberOfAcroNodesAfterDeleting);
    });
  });
  test('onSaveClick', () async {
    PositionAdministrationBloc bloc = PositionAdministrationBloc(objectbox);
    Node root = objectbox.findRoot();
    int length = root.children.length;
    String postureName = 'newPosture';
    expect(
        objectbox.positionBox
            .query(Position_.name.equals(postureName))
            .build()
            .find()
            .isEmpty,
        true);
    expect(root.children.containsElementWithLabel(postureName), false);
    bloc.onSaveClick(root, true, postureName);
    expect(
        objectbox.positionBox
            .query(Position_.name.equals(postureName))
            .build()
            .find()
            .isEmpty,
        false);
    root = objectbox.nodeBox.get(root.id)!;
    expect(root.children.containsElementWithLabel(postureName), true);
    expect(root.children.length, length + 1);
  });

  test('onEditClick', () async {
    PositionAdministrationBloc bloc = PositionAdministrationBloc(objectbox);
    Node child = objectbox.nodeBox.getAll().last;
    String testLabel = "testPosture";
    expect(
        objectbox.positionBox
            .query(Position_.name.equals(testLabel))
            .build()
            .find()
            .isEmpty,
        true);
    expect(child.label, isNot(equals(testLabel)));
    bloc.onEditClick(child, false, testLabel);
    expect(
        objectbox.positionBox
            .query(Position_.name.equals(testLabel))
            .build()
            .find()
            .isEmpty,
        false);
    expect(child.label, testLabel);
  });
}
