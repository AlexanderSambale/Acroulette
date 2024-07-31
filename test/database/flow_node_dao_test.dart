import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('flow_node_dao', () {
    late AppDatabase database;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    });

    tearDown(() async {
      await database.close();
    });
    test('count 0', () async {
      int? count = await database.flowNodeDao.count();
      int expected = 0;
      expect(count, expected);
    });

    test('create ninjaStar flow with with put and it should have id 1',
        () async {
      FlowNode ninjaStar = FlowNode('ninja star',
          ['ninja side star', 'reverse bird', 'ninja side star', 'buddha']);
      int? id = await database.flowNodeDao.put(ninjaStar);
      int expectedId = 1;
      expect(id, expectedId);
    });

    test('create multiple flows and delete flow with id 2', () async {
      List<FlowNode> flows = [
        FlowNode('ninja star',
            ['ninja side star', 'reverse bird', 'ninja side star', 'buddha']),
        FlowNode('ninja star2',
            ['ninja side star', 'reverse bird', 'ninja side star', 'buddha']),
        FlowNode('ninja star3',
            ['ninja side star', 'reverse bird', 'ninja side star', 'buddha'])
      ];
      List<int?> ids = await database.flowNodeDao.putAll(flows);
      int? count = await database.flowNodeDao.count();
      int expected = 3;
      expect(count, expected);
      await database.flowNodeDao.remove(ids[1]!);
      count = await database.flowNodeDao.count();
      expected = 2;
      expect(count, expected);
    });

    test('create multiple flows and findByName', () async {
      String name = 'ninja star2';
      List<FlowNode> flows = [
        FlowNode('ninja star',
            ['ninja side star', 'reverse bird', 'ninja side star', 'buddha']),
        FlowNode(name,
            ['ninja side star', 'reverse bird', 'ninja side star', 'buddha']),
        FlowNode('ninja star3',
            ['ninja side star', 'reverse bird', 'ninja side star', 'buddha'])
      ];
      await database.flowNodeDao.putAll(flows);
      FlowNode? flow = await database.flowNodeDao.findByName(name);
      expect(flow?.name, name);
    });

    test('create multiple flows and find flow by id 3', () async {
      List<FlowNode> flows = [
        FlowNode('ninja star',
            ['ninja side star', 'reverse bird', 'ninja side star', 'buddha']),
        FlowNode('ninja star2',
            ['ninja side star', 'reverse bird', 'ninja side star', 'buddha']),
        FlowNode('ninja star3',
            ['ninja side star', 'reverse bird', 'ninja side star', 'buddha'])
      ];
      List<int?> ids = await database.flowNodeDao.putAll(flows);
      FlowNode? flow = await database.flowNodeDao.findById(ids[2]!);
      int expected = 3;
      expect(flow?.id, expected);
    });
  });
}
