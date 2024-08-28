import 'package:acroulette/models/dao/node_node_dao.dart';
import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/relations/node_node.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('flow_node_dao', () {
    late AppDatabase database;
    late NodeNodeDao nodeNodeDao;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
      nodeNodeDao = database.nodeNodeDao;
    });

    tearDown(() async {
      await database.close();
    });

    group(
      "create",
      () {
        test(
          "parent child relationship",
          () async {
            int childId = 2, parentId = 1;
            NodeNode nodeNode = NodeNode(parentId, childId);
            await nodeNodeDao.insertObject(nodeNode);
            List<NodeNode> nodeNodesByChild =
                await nodeNodeDao.findByChildId(childId);
            expect(nodeNodesByChild, isNotEmpty);
            List<NodeNode> nodeNodesByParent =
                await nodeNodeDao.findByParentId(parentId);
            expect(nodeNodesByParent, isNotEmpty);
          },
        );

        test(
          "multiple parent child relationships",
          () async {
            int parentId = 1;
            List<NodeNode> children = [
              NodeNode(parentId, 2),
              NodeNode(parentId, 3),
              NodeNode(parentId, 4)
            ];
            await nodeNodeDao.insertObjects(children);
            List<NodeNode> nodeNodesByParent =
                await nodeNodeDao.findByParentId(parentId);
            expect(nodeNodesByParent.length, children.length);
          },
        );
      },
    );

    group(
      "read",
      () {
        test(
          "by parent id",
          () async {
            int childId = 2, parentId = 1;
            NodeNode nodeNode = NodeNode(parentId, childId);
            await nodeNodeDao.insertObject(nodeNode);
            List<NodeNode> nodeNodesByParent =
                await nodeNodeDao.findByParentId(parentId);
            expect(nodeNodesByParent, isNotEmpty);
          },
        );

        test(
          "by child id",
          () async {
            int childId = 2, parentId = 1;
            NodeNode nodeNode = NodeNode(parentId, childId);
            await nodeNodeDao.insertObject(nodeNode);
            List<NodeNode> nodeNodesByChild =
                await nodeNodeDao.findByChildId(childId);
            expect(nodeNodesByChild, isNotEmpty);
          },
        );
      },
    );

    // no update methods

    group(
      "delete",
      () {
        test(
          "by parent id",
          () async {
            int childId = 2, parentId = 1;
            NodeNode nodeNode = NodeNode(parentId, childId);
            await nodeNodeDao.insertObject(nodeNode);
            List<NodeNode> nodeNodesByParent =
                await nodeNodeDao.findByParentId(parentId);
            expect(nodeNodesByParent, isNotEmpty);
            await nodeNodeDao.removeObject(nodeNode);
            nodeNodesByParent = await nodeNodeDao.findByParentId(parentId);
            expect(nodeNodesByParent, isEmpty);
          },
        );

        test(
          "by child id",
          () async {
            int childId = 2, parentId = 1;
            NodeNode nodeNode = NodeNode(parentId, childId);
            await nodeNodeDao.insertObject(nodeNode);
            List<NodeNode> nodeNodesByChild =
                await nodeNodeDao.findByChildId(childId);
            expect(nodeNodesByChild, isNotEmpty);
            await nodeNodeDao.removeObject(nodeNode);
            nodeNodesByChild = await nodeNodeDao.findByChildId(childId);
            expect(nodeNodesByChild, isEmpty);
          },
        );

        test(
          "parent child relationship",
          () async {
            int childId = 2, parentId = 1;
            NodeNode nodeNode = NodeNode(parentId, childId);
            await nodeNodeDao.insertObject(nodeNode);
          },
        );

        test(
          "by parent ids",
          () async {
            int parentId1 = 1, parentId2 = 5, parentId3 = 6;
            List<NodeNode> children = [
              NodeNode(parentId1, 2),
              NodeNode(parentId1, 3),
              NodeNode(parentId1, 4),
              NodeNode(parentId2, 2),
              NodeNode(parentId2, 3),
              NodeNode(parentId2, 4),
              NodeNode(parentId3, 2),
              NodeNode(parentId3, 3),
              NodeNode(parentId3, 4),
            ];
            await nodeNodeDao.insertObjects(children);
            await nodeNodeDao
                .deleteByParentIds([parentId1, parentId2, parentId3]);
            List<NodeNode> nodeNodesByParent1 =
                    await nodeNodeDao.findByParentId(parentId1),
                nodeNodesByParent2 =
                    await nodeNodeDao.findByParentId(parentId2),
                nodeNodesByParent3 =
                    await nodeNodeDao.findByParentId(parentId3);
            expect(nodeNodesByParent1, isEmpty);
            expect(nodeNodesByParent2, isEmpty);
            expect(nodeNodesByParent3, isEmpty);
          },
        );
      },
    );
  });
}
