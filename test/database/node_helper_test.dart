import 'package:acroulette/helper/node_helper.dart';
import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/entities/node_entity.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/storage_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../testdata/trees.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;
  late StorageProvider storageProvider;
  late NodeHelper nodeBox;

  setUp(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    storageProvider = await StorageProvider.create(database);
    nodeBox = storageProvider.nodeBox;
  });

  tearDown(() async {
    await database.close();
  });
  group(
    "enableOrDisable",
    () {
      test(
        "simple tree switched on to switch off",
        () async {
          Node simpleTree = createSimpleTreeSwitchedOn();
          int simpleTreeId =
              await storageProvider.nodeBox.insertTree(simpleTree, null);
          NodeEntity? loadedTreeEntity = await storageProvider.nodeBox.nodeDao
              .findEntityById(simpleTreeId);
          Node loadedTree = (await storageProvider.nodeBox
              .toNodeWithChildren(loadedTreeEntity))!;
          expect(loadedTree.isSwitched, true);
          expect(loadedTree.isEnabled, true);
          expect(loadedTree.children[0].isEnabled, true);
          expect(loadedTree.children[1].isEnabled, false);
          expect(loadedTree.children[2].isEnabled, true);
          await nodeBox.enableOrDisable(loadedTreeEntity!, false);
          loadedTreeEntity = await storageProvider.nodeBox.nodeDao
              .findEntityById(simpleTreeId);
          loadedTree = (await storageProvider.nodeBox
              .toNodeWithChildren(loadedTreeEntity))!;
          expect(loadedTree.isSwitched, false);
          expect(loadedTree.isEnabled, true);
          expect(loadedTree.children[0].isEnabled, false);
          expect(loadedTree.children[1].isEnabled, false);
          expect(loadedTree.children[2].isEnabled, false);
        },
      );

      test(
        "simple tree switched off to switch on",
        () async {
          Node simpleTree = createSimpleTreeSwitchedOff();
          int simpleTreeId =
              await storageProvider.nodeBox.insertTree(simpleTree, null);
          NodeEntity? loadedTreeEntity = await storageProvider.nodeBox.nodeDao
              .findEntityById(simpleTreeId);
          Node loadedTree = (await storageProvider.nodeBox
              .toNodeWithChildren(loadedTreeEntity))!;
          expect(loadedTree.isSwitched, false);
          expect(loadedTree.isEnabled, true);
          expect(loadedTree.children[0].isEnabled, false);
          expect(loadedTree.children[1].isEnabled, false);
          expect(loadedTree.children[2].isEnabled, false);

          await nodeBox.enableOrDisable(loadedTreeEntity!, true);
          loadedTreeEntity = await storageProvider.nodeBox.nodeDao
              .findEntityById(simpleTreeId);
          loadedTree = (await storageProvider.nodeBox
              .toNodeWithChildren(loadedTreeEntity))!;
          expect(loadedTree.isSwitched, true);
          expect(loadedTree.isEnabled, true);
          expect(loadedTree.children[0].isEnabled, true);
          expect(loadedTree.children[1].isEnabled, true);
          expect(loadedTree.children[2].isEnabled, true);
        },
      );
      test(
        "complex tree switched on to switch off",
        () async {
          Node complexTree = createComplexTreeSwitchedOn();
          int complexTreeId =
              await storageProvider.nodeBox.insertTree(complexTree, null);
          NodeEntity? loadedTreeEntity = await storageProvider.nodeBox.nodeDao
              .findEntityById(complexTreeId);
          Node loadedTree = (await storageProvider.nodeBox
              .toNodeWithChildren(loadedTreeEntity))!;
          expect(loadedTree.isSwitched, true);
          expect(loadedTree.isEnabled, true);
          expect(loadedTree.children[0].isEnabled, true);
          expect(loadedTree.children[1].isEnabled, true);
          expect(loadedTree.children[2].isEnabled, true);

          expect(loadedTree.children[0].children[0].isEnabled, true);
          expect(loadedTree.children[0].children[1].isEnabled, false);
          expect(loadedTree.children[0].children[2].isEnabled, true);

          expect(loadedTree.children[1].children[0].isEnabled, false);
          expect(loadedTree.children[1].children[1].isEnabled, false);
          expect(loadedTree.children[1].children[2].isEnabled, false);

          expect(loadedTree.children[2].children[0].isEnabled, true);
          expect(loadedTree.children[2].children[1].isEnabled, false);
          expect(loadedTree.children[2].children[2].isEnabled, true);
          await nodeBox.enableOrDisable(loadedTreeEntity!, false);
          loadedTreeEntity = await storageProvider.nodeBox.nodeDao
              .findEntityById(complexTreeId);
          loadedTree = (await storageProvider.nodeBox
              .toNodeWithChildren(loadedTreeEntity))!;
          expect(loadedTree.isSwitched, false);
          expect(loadedTree.isEnabled, true);
          expect(loadedTree.children[0].isEnabled, false);
          expect(loadedTree.children[1].isEnabled, false);
          expect(loadedTree.children[2].isEnabled, false);

          expect(loadedTree.children[0].children[0].isEnabled, false);
          expect(loadedTree.children[0].children[1].isEnabled, false);
          expect(loadedTree.children[0].children[2].isEnabled, false);

          expect(loadedTree.children[1].children[0].isEnabled, false);
          expect(loadedTree.children[1].children[1].isEnabled, false);
          expect(loadedTree.children[1].children[2].isEnabled, false);

          expect(loadedTree.children[2].children[0].isEnabled, false);
          expect(loadedTree.children[2].children[1].isEnabled, false);
          expect(loadedTree.children[2].children[2].isEnabled, false);
        },
      );

      test(
        "complex tree switched off to switch on, subtress switched off",
        () async {
          Node complexTree = createComplexTreeSwitchedOff();
          int complexTreeId =
              await storageProvider.nodeBox.insertTree(complexTree, null);
          NodeEntity? loadedTreeEntity = await storageProvider.nodeBox.nodeDao
              .findEntityById(complexTreeId);
          Node loadedTree = (await storageProvider.nodeBox
              .toNodeWithChildren(loadedTreeEntity))!;
          expect(loadedTree.isSwitched, false);
          expect(loadedTree.isEnabled, true);
          expect(loadedTree.children[0].isEnabled, false);
          expect(loadedTree.children[1].isEnabled, false);
          expect(loadedTree.children[2].isEnabled, false);

          expect(loadedTree.children[0].children[0].isEnabled, false);
          expect(loadedTree.children[0].children[1].isEnabled, false);
          expect(loadedTree.children[0].children[2].isEnabled, false);

          expect(loadedTree.children[1].children[0].isEnabled, false);
          expect(loadedTree.children[1].children[1].isEnabled, false);
          expect(loadedTree.children[1].children[2].isEnabled, false);

          expect(loadedTree.children[2].children[0].isEnabled, false);
          expect(loadedTree.children[2].children[1].isEnabled, false);
          expect(loadedTree.children[2].children[2].isEnabled, false);
          await nodeBox.enableOrDisable(loadedTreeEntity!, true);
          loadedTreeEntity = await storageProvider.nodeBox.nodeDao
              .findEntityById(complexTreeId);
          loadedTree = (await storageProvider.nodeBox
              .toNodeWithChildren(loadedTreeEntity))!;
          expect(loadedTree.isSwitched, true);
          expect(loadedTree.isEnabled, true);
          expect(loadedTree.children[0].isEnabled, true);
          expect(loadedTree.children[1].isEnabled, true);
          expect(loadedTree.children[2].isEnabled, true);

          expect(loadedTree.children[0].children[0].isEnabled, false);
          expect(loadedTree.children[0].children[1].isEnabled, false);
          expect(loadedTree.children[0].children[2].isEnabled, false);

          expect(loadedTree.children[1].children[0].isEnabled, false);
          expect(loadedTree.children[1].children[1].isEnabled, false);
          expect(loadedTree.children[1].children[2].isEnabled, false);

          expect(loadedTree.children[2].children[0].isEnabled, false);
          expect(loadedTree.children[2].children[1].isEnabled, false);
          expect(loadedTree.children[2].children[2].isEnabled, false);
        },
      );

      test(
        "complex tree switched off to switch on, subtrees switched on",
        () async {
          Node complexTree =
              createComplexTreeSwitchedOff(childrenSwitched: true);
          int complexTreeId =
              await storageProvider.nodeBox.insertTree(complexTree, null);
          NodeEntity? loadedTreeEntity = await storageProvider.nodeBox.nodeDao
              .findEntityById(complexTreeId);
          Node loadedTree = (await storageProvider.nodeBox
              .toNodeWithChildren(loadedTreeEntity))!;
          expect(loadedTree.isSwitched, false);
          expect(loadedTree.isEnabled, true);
          expect(loadedTree.children[0].isEnabled, false);
          expect(loadedTree.children[1].isEnabled, false);
          expect(loadedTree.children[2].isEnabled, false);

          expect(loadedTree.children[0].children[0].isEnabled, false);
          expect(loadedTree.children[0].children[1].isEnabled, false);
          expect(loadedTree.children[0].children[2].isEnabled, false);

          expect(loadedTree.children[1].children[0].isEnabled, false);
          expect(loadedTree.children[1].children[1].isEnabled, false);
          expect(loadedTree.children[1].children[2].isEnabled, false);

          expect(loadedTree.children[2].children[0].isEnabled, false);
          expect(loadedTree.children[2].children[1].isEnabled, false);
          expect(loadedTree.children[2].children[2].isEnabled, false);
          await nodeBox.enableOrDisable(loadedTreeEntity!, true);
          loadedTreeEntity = await storageProvider.nodeBox.nodeDao
              .findEntityById(complexTreeId);
          loadedTree = (await storageProvider.nodeBox
              .toNodeWithChildren(loadedTreeEntity))!;
          expect(loadedTree.isSwitched, true);
          expect(loadedTree.isEnabled, true);
          expect(loadedTree.children[0].isEnabled, true);
          expect(loadedTree.children[1].isEnabled, true);
          expect(loadedTree.children[2].isEnabled, true);

          expect(loadedTree.children[0].isSwitched, true);
          expect(loadedTree.children[1].isSwitched, false);
          expect(loadedTree.children[2].isSwitched, true);

          expect(loadedTree.children[0].children[0].isEnabled, true);
          expect(loadedTree.children[0].children[1].isEnabled, true);
          expect(loadedTree.children[0].children[2].isEnabled, true);

          expect(loadedTree.children[1].children[0].isEnabled, false);
          expect(loadedTree.children[1].children[1].isEnabled, false);
          expect(loadedTree.children[1].children[2].isEnabled, false);

          expect(loadedTree.children[2].children[0].isEnabled, true);
          expect(loadedTree.children[2].children[1].isEnabled, true);
          expect(loadedTree.children[2].children[2].isEnabled, true);
        },
      );
    },
  );
}
