import 'package:acroulette/models/dao/flow_node_dao.dart';
import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/entities/flow_node_entity.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('flow_node_dao', () {
    late AppDatabase database;
    late FlowNodeDao flowNodeDao;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
      flowNodeDao = database.flowNodeDao;
    });

    tearDown(() async {
      await database.close();
    });

    FlowNode generateFlowNode({
      String name = 'ninja star',
    }) {
      return FlowNode(name, [
        'ninja side star',
        'reverse bird',
        'ninja side star',
        'buddha',
      ]);
    }

    FlowNodeEntity generateFlowNodeEntity({
      String name = 'ninja star',
    }) {
      return FlowNodeDao.toFlowNodeEntity(generateFlowNode(name: name))!;
    }

    Future<List<int>> insertFlowNodeEntities() async {
      List<FlowNodeEntity> flows = [
        generateFlowNodeEntity(),
        generateFlowNodeEntity(name: 'ninja star2'),
        generateFlowNodeEntity(name: 'ninja star3'),
      ];
      List<int> flowIds = await flowNodeDao.insertObjects(flows);
      return flowIds;
    }

    Future<List<int>> insertFlowNodes() async {
      List<FlowNode> flows = [
        generateFlowNode(),
        generateFlowNode(name: 'ninja star2'),
        generateFlowNode(name: 'ninja star3'),
      ];
      List<int> flowIds = await flowNodeDao.putAll(flows);
      return flowIds;
    }

    group('create', () {
      test(
        "FlowNodeEntity",
        () async {
          FlowNodeEntity flow = generateFlowNodeEntity();
          int flowId = await flowNodeDao.insertObject(flow);
          expect(flowId, 1);
        },
      );

      test(
        "FlowNode",
        () async {
          FlowNode flow = generateFlowNode();
          int flowId = await flowNodeDao.create(flow);
          expect(flowId, 1);
        },
      );

      test(
        "FlowNodeEntities",
        () async {
          List<int> flowIds = await insertFlowNodeEntities();
          expect(flowIds, [1, 2, 3]);
        },
      );

      test(
        "FlowNodes",
        () async {
          List<int> flowIds = await insertFlowNodes();
          expect(flowIds, [1, 2, 3]);
        },
      );
    });

    group(
      'read',
      () {
        test(
          "FlowNodeEntity by name",
          () async {
            String name = 'FlowNodeEntityName';
            await flowNodeDao.insertObject(generateFlowNodeEntity(name: name));
            FlowNodeEntity? entityByName =
                await flowNodeDao.findEntityByName(name);
            expect(entityByName, isNotNull);
          },
        );

        test(
          "FlowNode by name",
          () async {
            String name = 'FlowNodeEntityName';
            await flowNodeDao.create(generateFlowNode(name: name));
            FlowNode? flowByName = await flowNodeDao.findByName(name);
            expect(flowByName, isNotNull);
          },
        );

        test(
          "all FlowNodeEntities",
          () async {
            int expectedLength = (await insertFlowNodeEntities()).length;
            List<FlowNodeEntity> foundFlows = await flowNodeDao.findAll();
            expect(foundFlows.length, expectedLength);
          },
        );

        test(
          "FlowNodeEntity by id",
          () async {
            await insertFlowNodeEntities(); // insert 3
            FlowNodeEntity? flow = await flowNodeDao.findEntityById(2);
            expect(flow, isNotNull);
            flow = await flowNodeDao.findEntityById(5);
            expect(flow, isNull);
          },
        );

        test("FlowNode by id", () async {
          await insertFlowNodes(); // insert 3
          FlowNode? flow = await flowNodeDao.findById(2);
          expect(flow, isNotNull);
          flow = await flowNodeDao.findById(5);
          expect(flow, isNull);
        });
      },
    );

    group('update', () {
      test(
        "name to test",
        () async {
          String name = 'FlowNodeEntityName';
          await flowNodeDao.insertObject(generateFlowNodeEntity(name: name));
          FlowNode? nodeToEdit = await flowNodeDao.findByName(name);
          expect(nodeToEdit, isNotNull);
          String newName = 'test';
          nodeToEdit!.name = newName;
          flowNodeDao.updateFlowNode(nodeToEdit);
          FlowNode? nodeWithNameTest = await flowNodeDao.findByName(newName);
          expect(nodeWithNameTest, isNotNull);
          expect(nodeWithNameTest!.id, nodeToEdit.id);
        },
      );
    });
    group('delete', () {
      test(
        "flow",
        () async {
          String name = 'FlowNodeEntityName';
          await flowNodeDao.insertObject(generateFlowNodeEntity(name: name));
          FlowNode? nodeToRemove = await flowNodeDao.findByName(name);
          expect(nodeToRemove, isNotNull);
          flowNodeDao.removeFlowNode(nodeToRemove!);
          FlowNode? shouldBeRemoved = await flowNodeDao.findByName(name);
          expect(shouldBeRemoved, isNull);
        },
      );
    });

    test('count 0', () async {
      int? count = await flowNodeDao.count();
      int expected = 0;
      expect(count, expected);
    });

    test('create multiple flows and delete flow with id 2', () async {
      List<FlowNode> flows = [
        generateFlowNode(),
        generateFlowNode(name: 'ninja star2'),
        generateFlowNode(name: 'ninja star3'),
      ];
      List<int?> ids = await flowNodeDao.putAll(flows);
      int? count = await flowNodeDao.count();
      int expected = 3;
      expect(count, expected);
      await flowNodeDao.remove(ids[1]!);
      count = await flowNodeDao.count();
      expected = 2;
      expect(count, expected);
    });

    test('create multiple flows and findByName', () async {
      String name = 'ninja star2';
      List<FlowNode> flows = [
        generateFlowNode(),
        generateFlowNode(name: name),
        generateFlowNode(name: 'ninja star3'),
      ];
      await flowNodeDao.putAll(flows);
      FlowNode? flow = await flowNodeDao.findByName(name);
      expect(flow?.name, name);
    });

    test('create multiple flows and find flow by id 3', () async {
      List<FlowNode> flows = [
        generateFlowNode(),
        generateFlowNode(name: 'ninja star2'),
        generateFlowNode(name: 'ninja star3'),
      ];
      List<int?> ids = await flowNodeDao.putAll(flows);
      FlowNode? flow = await flowNodeDao.findById(ids[2]!);
      int expected = 3;
      expect(flow?.id, expected);
    });
  });
}
