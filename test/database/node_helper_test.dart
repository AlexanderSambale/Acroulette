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
          Node simpleTree = createSimpleTreeEnabled();
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
          expect(loadedTree.isEnabled, false);
          expect(loadedTree.children[0].isEnabled, false);
          expect(loadedTree.children[1].isEnabled, false);
          expect(loadedTree.children[2].isEnabled, false);
        },
      );

      test(
        "simple tree switched off to switch on",
        () async {
          Node simpleTree = createSimpleTreeDisabled();
          int simpleTreeId =
              await storageProvider.nodeBox.insertTree(simpleTree, null);
          NodeEntity? loadedTreeEntity = await storageProvider.nodeBox.nodeDao
              .findEntityById(simpleTreeId);
          Node loadedTree = (await storageProvider.nodeBox
              .toNodeWithChildren(loadedTreeEntity))!;
          expect(loadedTree.isSwitched, false);
          expect(loadedTree.isEnabled, false);
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
          expect(loadedTree.children[1].isEnabled, false);
          expect(loadedTree.children[2].isEnabled, true);
        },
      );
    },
  );
}
