import 'package:acroulette/bloc/position_administration/position_administration_bloc.dart';
import 'package:acroulette/constants/model.dart';
import 'package:acroulette/constants/validator.dart';
import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/entities/node_entity.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/db_controller.dart';
import 'package:flutter_test/flutter_test.dart';

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

Future<Node> setupComplexTree(DBController dbController) async {
  Node complexTree = createComplexTree();
  complexTree.id = await dbController.nodeBox.insertTree(complexTree, null);
  return complexTree;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;
  late DBController dbController;

  setUp(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    dbController = await DBController.create(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('onDeleteClick', () {
    test('delete leaf', () async {
      PositionAdministrationBloc bloc =
          PositionAdministrationBloc(dbController);
      // create category, create leaf
      int categoryId =
          await dbController.nodeBox.createCategory(null, 'category');
      NodeEntity? category =
          await dbController.nodeBox.nodeDao.findEntityById(categoryId);
      int leafId = await dbController.nodeBox
          .createPosture(dbController.nodeBox.toNode(category!)!, 'leaf');
      NodeEntity? leaf =
          await dbController.nodeBox.nodeDao.findEntityById(leafId);
      // leaf exists
      expect(leaf, isNot(null));
      // delete leaf
      await bloc.onDeleteClick(dbController.nodeBox.toNode(leaf)!);
      leaf = await dbController.nodeBox.nodeDao.findEntityById(leafId);
      expect(leaf, equals(null));
    });

    test('delete node with children', () async {
      PositionAdministrationBloc bloc =
          PositionAdministrationBloc(dbController);
      int numberOfNodesBefore = (await dbController.nodeBox.count())!;
      Node complexTree = await setupComplexTree(dbController);
      int numberOfNodesAfterAdding = (await dbController.nodeBox.count())!;
      expect(numberOfNodesBefore, isNot(equals(numberOfNodesAfterAdding)));
      await bloc.onDeleteClick(complexTree);
      int numberOfNodesAfterDeleting = (await dbController.nodeBox.count())!;
      expect(numberOfNodesBefore, numberOfNodesAfterDeleting);
    });
  });

  test('onSaveClick', () async {
    PositionAdministrationBloc bloc = PositionAdministrationBloc(dbController);
    // create category
    int categoryId =
        await dbController.nodeBox.createCategory(null, 'category');
    NodeEntity? category =
        await dbController.nodeBox.nodeDao.findEntityById(categoryId);
    Node? parent = dbController.nodeBox.toNode(category);
    String postureName = 'newPosture';
    int numberOfNodesBeforeSaving = (await dbController.nodeBox.count())!;
    await bloc.onSaveClick(parent, true, postureName);
    int numberOfNodesAfterSaving = (await dbController.nodeBox.count())!;
    expect(numberOfNodesAfterSaving, numberOfNodesBeforeSaving + 1);
  });

  test('onEditClick', () async {
    PositionAdministrationBloc bloc = PositionAdministrationBloc(dbController);
    // create category, create leaf
    int categoryId =
        await dbController.nodeBox.createCategory(null, 'category');
    NodeEntity? category =
        await dbController.nodeBox.nodeDao.findEntityById(categoryId);
    int leafId = await dbController.nodeBox
        .createPosture(dbController.nodeBox.toNode(category!)!, 'leaf');
    NodeEntity? leaf =
        await dbController.nodeBox.nodeDao.findEntityById(leafId);
    String testLabel = "testPosture";
    expect(leaf!.label, isNot(equals(testLabel)));
    await bloc.onEditClick(
        dbController.nodeBox.toNode(leaf)!, false, testLabel);
    leaf = await dbController.nodeBox.nodeDao.findEntityById(leafId);
    expect(leaf!.label, testLabel);
  });

  group('onSwitchClick', () {
    test('click false', () async {
      PositionAdministrationBloc bloc =
          PositionAdministrationBloc(dbController);
      Node simpleTree = createSimpleTree();
      int simpleTreeId =
          await dbController.nodeBox.insertTree(simpleTree, null);
      NodeEntity? loadedTreeEntity =
          await dbController.nodeBox.nodeDao.findEntityById(simpleTreeId);
      Node? loadedTree =
          await dbController.nodeBox.toNodeWithChildren(loadedTreeEntity);
      expect(loadedTree, isNotNull);
      expect(simpleTree.isSwitched, loadedTree!.isSwitched);
      List<bool> isEnabledList = [];
      for (Node child in loadedTree.children) {
        isEnabledList.add(child.isEnabled);
      }
      expect(isEnabledList, [true, false, true]);
      await bloc.onSwitch(false, loadedTree);
      loadedTreeEntity =
          await dbController.nodeBox.nodeDao.findEntityById(simpleTreeId);
      loadedTree =
          await dbController.nodeBox.toNodeWithChildren(loadedTreeEntity);
      expect(loadedTree!.isSwitched, false);
      List<bool> isEnabledListAfter = [];
      for (Node child in loadedTree.children) {
        isEnabledListAfter.add(child.isEnabled);
      }
      expect(isEnabledListAfter, [false, false, false]);
    });

    test('click true', () async {
      PositionAdministrationBloc bloc =
          PositionAdministrationBloc(dbController);
      Node simpleTree = createSimpleTree();
      simpleTree.isSwitched = false;
      int simpleTreeId =
          await dbController.nodeBox.insertTree(simpleTree, null);
      NodeEntity? loadedTreeEntity =
          await dbController.nodeBox.nodeDao.findEntityById(simpleTreeId);
      Node? loadedTree =
          await dbController.nodeBox.toNodeWithChildren(loadedTreeEntity);
      expect(loadedTree, isNotNull);
      expect(simpleTree.isSwitched, loadedTree!.isSwitched);
      List<bool> isEnabledList = [];
      for (Node child in loadedTree.children) {
        isEnabledList.add(child.isEnabled);
      }
      await bloc.onSwitch(true, loadedTree);
      loadedTreeEntity =
          await dbController.nodeBox.nodeDao.findEntityById(simpleTreeId);
      loadedTree =
          await dbController.nodeBox.toNodeWithChildren(loadedTreeEntity);
      expect(loadedTree!.isSwitched, true);
      List<bool> isEnabledListAfter = [];
      for (Node child in loadedTree.children) {
        isEnabledListAfter.add(child.isEnabled);
      }
      expect(isEnabledListAfter, isEnabledList);
    });
  });

  group('validate', () {
    test('validate posture', () async {
      PositionAdministrationBloc bloc =
          PositionAdministrationBloc(dbController);
      // create category, create leaf
      int categoryId =
          await dbController.nodeBox.createCategory(null, 'category');
      NodeEntity? category =
          await dbController.nodeBox.nodeDao.findEntityById(categoryId);
      int leafId = await dbController.nodeBox
          .createPosture(dbController.nodeBox.toNode(category!)!, 'test leaf');
      NodeEntity? leafEntity =
          await dbController.nodeBox.nodeDao.findEntityById(leafId);
      String testLabel = "testPosture";
      Node? parent = dbController.nodeBox.toNode(category);
      Node? leaf = dbController.nodeBox.toNode(leafEntity);
      parent!.addNode(leaf!);
      expect(bloc.validator(parent, true, ''), enterText);
      expect(bloc.validator(parent, true, leaf.label),
          existsText(postureLabel, leaf.label));
      expect(bloc.validator(parent, true, testLabel), null);
    });

    test('validate category', () async {
      PositionAdministrationBloc bloc =
          PositionAdministrationBloc(dbController);
      Node complexTree = await setupComplexTree(dbController);
      String testLabel = "testCategory";
      expect(bloc.validator(complexTree, false, ''), enterText);
      expect(bloc.validator(complexTree, false, complexTree.label), null);
      expect(bloc.validator(complexTree, false, testLabel), null);
    });
  });
}
