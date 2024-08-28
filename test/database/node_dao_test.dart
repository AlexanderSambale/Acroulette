import 'package:acroulette/models/dao/node_dao.dart';
import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/entities/node_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('node_dao', () {
    late AppDatabase database;
    late NodeDao nodeDao;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
      nodeDao = database.nodeDao;
    });

    tearDown(() async {
      await database.close();
    });

    Future<List<int>> insertNodes() async {
      List<NodeEntity> nodes = [
        NodeEntity.optional(),
        NodeEntity.optional(),
        NodeEntity.optional(),
      ];
      List<int> ids = await nodeDao.insertObjects(nodes);
      return ids;
    }

    group(
      "create",
      () {
        test(
          "NodeEntity",
          () async {
            int? id = await nodeDao.insertObject(NodeEntity.optional());
            expect(id, isNotNull);
          },
        );

        test(
          "NodeEntities",
          () async {
            List<int> ids = await insertNodes();
            expect(ids, isNotEmpty);
          },
        );
      },
    );

    group(
      "read",
      () {
        test(
          "all",
          () async {
            List<int> ids = await insertNodes();
            List<NodeEntity> nodes = await nodeDao.findAll();
            expect(nodes.length, ids.length);
          },
        );

        test(
          "all by id",
          () async {
            await insertNodes();
            List<int> ids = [1, 3];
            List<NodeEntity?> nodes = await nodeDao.findAllById(ids);
            expect(nodes.length, ids.length);
          },
        );

        test(
          "all by id, with null values",
          () async {
            await insertNodes();
            List<int> ids = [1, 7, 3, 5];
            List<NodeEntity?> nodes = await nodeDao.findAllById(ids);
            expect(nodes.where((node) => node == null).toList().length, 2);
          },
        );

        test(
          "by id",
          () async {
            await insertNodes();
            int id = 3;
            NodeEntity? node = await nodeDao.findEntityById(id);
            expect(node, isNotNull);
          },
        );

        test(
          "by id, not found",
          () async {
            int id = 3;
            NodeEntity? node = await nodeDao.findEntityById(id);
            expect(node, isNull);
          },
        );
      },
    );

    group(
      "update",
      () {
        test(
          "node",
          () async {
            NodeEntity nodeToEdit = NodeEntity.optional();
            int? id = await nodeDao.insertObject(nodeToEdit);
            String label = 'test';
            NodeEntity editedNode =
                nodeToEdit.copyWith(label: label, autoId: id);
            await nodeDao.updateObject(editedNode);
            NodeEntity? foundNode = await nodeDao.findEntityById(id);
            expect(foundNode, isNotNull);
            expect(foundNode!.label, label);
          },
        );
      },
    );

    group(
      "delete",
      () {
        test(
          "node",
          () async {
            int? id = await nodeDao.insertObject(NodeEntity.optional());
            NodeEntity? nodeToDelete = await nodeDao.findEntityById(id);
            expect(nodeToDelete, isNotNull);
            await nodeDao.removeObject(nodeToDelete!);
            nodeToDelete = await nodeDao.findEntityById(id);
            expect(nodeToDelete, isNull);
          },
        );

        test(
          "node by id",
          () async {
            int? id = await nodeDao.insertObject(NodeEntity.optional());
            NodeEntity? nodeToDelete = await nodeDao.findEntityById(id);
            expect(nodeToDelete, isNotNull);
            await nodeDao.deleteById(id);
            nodeToDelete = await nodeDao.findEntityById(id);
            expect(nodeToDelete, isNull);
          },
        );

        test(
          "node by ids",
          () async {
            await insertNodes();
            await nodeDao.deleteByIds([1, 3]);
            List<NodeEntity> nodes = await nodeDao.findAll();
            expect(nodes.length, 1);
          },
        );
      },
    );

    test('count 0', () async {
      int? count = await nodeDao.count();
      int expected = 0;
      expect(count, expected);
    });

    test('count 1', () async {
      await nodeDao.insertObject(NodeEntity.optional());
      int? count = await nodeDao.count();
      int expected = 1;
      expect(count, expected);
    });
  });
}
