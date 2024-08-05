import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/relations/node_without_parent.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('node_without_parents_dao', () {
    late AppDatabase database;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    });

    tearDown(() async {
      await database.close();
    });

    test('count 0', () async {
      int count = (await database.nodeWithoutParentDao.findAll()).length;
      int expected = 0;
      expect(count, expected);
    });

    test('create node without parent with id 1', () async {
      int expectedId = 1;
      var nodeWithoutParent = NodeWithoutParent(expectedId);
      int id =
          await database.nodeWithoutParentDao.insertObject(nodeWithoutParent);
      expect(id, expectedId);
    });

    test('create nodes without parent with id 1 and 2', () async {
      await database.nodeWithoutParentDao.insertObject(NodeWithoutParent(1));
      await database.nodeWithoutParentDao.insertObject(NodeWithoutParent(2));
      int count = (await database.nodeWithoutParentDao.findAll()).length;
      int expected = 2;
      expect(count, expected);
      await database.nodeWithoutParentDao.removeObject(NodeWithoutParent(1));
      count = (await database.nodeWithoutParentDao.findAll()).length;
      expected = 1;
      expect(count, expected);
    });
  });
}
