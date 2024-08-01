import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/entities/acro_node.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('acro_node_dao', () {
    late AppDatabase database;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    });

    tearDown(() async {
      await database.close();
    });

    test('count 0', () async {
      int? count = await database.acroNodeDao.count();
      int expected = 0;
      expect(count, expected);
    });

    test('create AcroNode', () async {
      AcroNode acroNode = AcroNode(null, true, 'label');
      await database.acroNodeDao.put(acroNode);
      int? count = await database.acroNodeDao.count();
      int expected = 1;
      expect(count, expected);
    });

    test('create AcroNodes', () async {
      List<AcroNode> acroNodes = [
        AcroNode(null, true, 'label1'),
        AcroNode(null, true, 'label1'),
        AcroNode(null, true, 'label1'),
      ];
      await database.acroNodeDao.putAll(acroNodes);
      int? count = await database.acroNodeDao.count();
      int expected = 3;
      expect(count, expected);
    });

    test('remove AcroNode by id', () async {
      List<AcroNode> acroNodes = [
        AcroNode(null, true, 'label1'),
        AcroNode(null, true, 'label1'),
        AcroNode(null, true, 'label1'),
      ];
      await database.acroNodeDao.putAll(acroNodes);
      int? count = await database.acroNodeDao.count();
      int expected = 3;
      expect(count, expected);
      await database.acroNodeDao.removeById(2);
      List<AcroNode?> acroNodes2 = await database.acroNodeDao.findAll();
      expect(acroNodes2[0]?.id, 1);
      expect(acroNodes2[1]?.id, 3);
    });

    test('delete AcroNodes by ids', () async {
      List<AcroNode> acroNodes = [
        AcroNode(null, true, 'label1'),
        AcroNode(null, true, 'label1'),
        AcroNode(null, true, 'label1'),
      ];
      await database.acroNodeDao.putAll(acroNodes);
      int? count = await database.acroNodeDao.count();
      int expected = 3;
      expect(count, expected);
      await database.acroNodeDao.deleteByIds([1, 3]);
      count = await database.acroNodeDao.count();
      expected = 1;
      expect(count, expected);
    });
  });
}
