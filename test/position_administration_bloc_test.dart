import 'dart:io';

import 'package:acroulette/bloc/position_administration/position_administration_bloc.dart';
import 'package:acroulette/constants/model.dart';
import 'package:acroulette/constants/validator.dart';
import 'package:acroulette/models/entities/acro_node.dart';
import 'package:acroulette/helper/objectbox/to_many_extension.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/db_controller.dart';
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

Node setupComplexTree(DBController dbController) {
  Node root = dbController.findNodesWithoutParent()[0];
  Node complexTree = createComplexTree();
  root.children.add(complexTree);
  dbController.putNode(root);
  return complexTree;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Isar store;
  late DBController dbController;
  final dir = Directory('position_administration_bloc_testdata');

  setUp(() async {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
    await dir.create();
    store = await Isar.open(
      [
        SettingsPairSchema,
        PositionSchema,
        AcroNodeSchema,
        FlowNodeSchema,
        NodeSchema,
      ],
      directory: dir.path,
    );
    dbController = await DBController.create(store);
  });

  tearDown(() {
    store.close();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  group('onDeleteClick', () {
    test('delete leaf', () async {
      PositionAdministrationBloc bloc =
          PositionAdministrationBloc(dbController);
      Node child = dbController.nodeBox.where().findAllSync().last;
      Node parent = dbController.findParent(child)!;
      expect(parent.children.containsElementWithId(child.id), true);
      int length = parent.children.length;
      expect(
          dbController.positionBox
              .where()
              .nameEqualTo(child.label!)
              .findAllSync()
              .isEmpty,
          false);
      bloc.onDeleteClick(child);
      expect(
          dbController.positionBox
              .where()
              .nameEqualTo(child.label!)
              .findAllSync()
              .isEmpty,
          true);
      parent = dbController.nodeBox.getSync(parent.id)!;
      expect(parent.children.containsElementWithId(child.id), false);
      expect(parent.children.length + 1, length);
    });

    test('delete node with children', () async {
      PositionAdministrationBloc bloc =
          PositionAdministrationBloc(dbController);
      int numberOfNodesBefore = dbController.nodeBox.countSync();
      int numberOfAcroNodesBefore = dbController.acroNodeBox.countSync();
      Node complexTree = setupComplexTree(dbController);
      int numberOfNodesAfterAdding = dbController.nodeBox.countSync();
      int numberOfAcroNodesAfterAdding = dbController.acroNodeBox.countSync();
      expect(numberOfNodesBefore, isNot(equals(numberOfNodesAfterAdding)));
      expect(
          numberOfAcroNodesBefore, isNot(equals(numberOfAcroNodesAfterAdding)));
      bloc.onDeleteClick(complexTree);
      int numberOfNodesAfterDeleting = dbController.nodeBox.countSync();
      int numberOfAcroNodesAfterDeleting = dbController.acroNodeBox.countSync();
      expect(numberOfNodesBefore, numberOfNodesAfterDeleting);
      expect(numberOfAcroNodesBefore, numberOfAcroNodesAfterDeleting);
    });
  });
  test('onSaveClick', () async {
    PositionAdministrationBloc bloc = PositionAdministrationBloc(dbController);
    List<Node> nodesWithoutParent = dbController.findNodesWithoutParent();
    int numberOfNodesWithoutParents = nodesWithoutParent.length;
    Node root = nodesWithoutParent[0];
    int length = root.children.length;
    String postureName = 'newPosture';
    expect(
        dbController.positionBox
            .where()
            .nameEqualTo(postureName)
            .findAllSync()
            .isEmpty,
        true);
    expect(root.children.containsElementWithLabel(true, postureName), false);
    bloc.onSaveClick(root, true, postureName);
    expect(
        dbController.positionBox
            .where()
            .nameEqualTo(postureName)
            .findAllSync()
            .isEmpty,
        false);
    root = dbController.nodeBox.getSync(root.id)!;
    expect(root.children.containsElementWithLabel(true, postureName), true);
    expect(root.children.length, length + 1);
    expect(numberOfNodesWithoutParents,
        dbController.findNodesWithoutParent().length);
  });

  test('onEditClick', () async {
    PositionAdministrationBloc bloc = PositionAdministrationBloc(dbController);
    Node child = dbController.nodeBox.where().findAllSync().last;
    String testLabel = "testPosture";
    expect(
        dbController.positionBox
            .where()
            .nameEqualTo(testLabel)
            .findAllSync()
            .isEmpty,
        true);
    expect(child.label, isNot(equals(testLabel)));
    bloc.onEditClick(child, false, testLabel);
    expect(
        dbController.positionBox
            .where()
            .nameEqualTo(testLabel)
            .findAllSync()
            .isEmpty,
        false);
    expect(child.label, testLabel);
  });

  group('onSwitchClick', () {
    test('click false', () async {
      PositionAdministrationBloc bloc =
          PositionAdministrationBloc(dbController);
      Node simpleTree = createSimpleTree();
      int simpleTreeId = await dbController.putNode(simpleTree);
      Node? loadedTree = dbController.nodeBox.getSync(simpleTreeId);
      expect(loadedTree, isNotNull);
      expect(simpleTree.acroNode.isSwitched, loadedTree!.acroNode.isSwitched);
      List<bool> enabledList = [];
      for (Node child in loadedTree.children.toList()) {
        enabledList.add(child.acroNode.isEnabled);
      }
      bloc.onSwitch(false, loadedTree);
      expect(loadedTree.acroNode.isSwitched, false);
      List<bool> enabledListAfter = [];
      for (Node child in loadedTree.children.toList()) {
        enabledListAfter.add(child.acroNode.isEnabled);
      }
      expect(enabledListAfter, [false, false, false]);
    });

    test('click true', () async {
      PositionAdministrationBloc bloc =
          PositionAdministrationBloc(dbController);
      Node simpleTree = createSimpleTree();
      simpleTree.acroNode.isSwitched = false;
      int simpleTreeId = await dbController.putNode(simpleTree);
      Node? loadedTree = dbController.nodeBox.getSync(simpleTreeId);
      expect(loadedTree, isNotNull);
      expect(simpleTree.acroNode.isSwitched, loadedTree!.acroNode.isSwitched);
      List<bool> enabledList = [];
      for (Node child in loadedTree.children.toList()) {
        enabledList.add(child.acroNode.isEnabled);
      }
      bloc.onSwitch(true, loadedTree);
      expect(loadedTree.acroNode.isSwitched, true);
      List<bool> enabledListAfter = [];
      for (Node child in loadedTree.children.toList()) {
        enabledListAfter.add(child.acroNode.isEnabled);
      }
      expect(enabledListAfter, enabledList);
    });
  });

  group('validate', () {
    test('validate posture', () async {
      PositionAdministrationBloc bloc =
          PositionAdministrationBloc(dbController);
      Node last = dbController.nodeBox.where().findAllSync().last;
      Node parent = dbController.findParent(last)!;
      String testLabel = "testPosture";
      expect(bloc.validator(parent, true, ''), enterText);
      expect(bloc.validator(parent, true, last.label),
          existsText(postureLabel, last.label!));
      expect(bloc.validator(parent, true, testLabel), null);
    });

    test('validate category', () async {
      PositionAdministrationBloc bloc =
          PositionAdministrationBloc(dbController);
      Node complexTree = setupComplexTree(dbController);
      String testLabel = "testCategory";
      expect(bloc.validator(complexTree, false, ''), enterText);
      expect(bloc.validator(complexTree, false, complexTree.label), null);
      expect(bloc.validator(complexTree, false, testLabel), null);
    });
  });
}
