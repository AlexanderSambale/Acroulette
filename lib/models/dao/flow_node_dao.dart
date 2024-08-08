import 'dart:typed_data';

import 'package:acroulette/helper/conversion.dart';
import 'package:acroulette/models/entities/flow_node_entity.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:floor/floor.dart';

@dao
abstract class FlowNodeDao {
  @Query('SELECT COUNT(*) FROM FlowNodeEntity')
  Future<int?> count();

  @Query('DELETE FROM FlowNodeEntity WHERE autoId = :id')
  Future<void> remove(int id);

  @Query('SELECT * FROM FlowNodeEntity WHERE name = :name')
  Future<FlowNodeEntity?> findEntityByName(String name);

  @Query('SELECT * FROM FlowNodeEntity')
  Future<List<FlowNodeEntity>> findAll();

  Future<FlowNode?> findByName(String name) async {
    return toFlowNode(await findEntityByName(name));
  }

  @Query('SELECT * FROM FlowNodeEntity WHERE autoId = :id')
  Future<FlowNodeEntity?> findEntityById(int id);

  Future<FlowNode?> findById(int id) async {
    return toFlowNode(await findEntityById(id));
  }

  @insert
  Future<int> insertObject(FlowNodeEntity object);

  @insert
  Future<List<int>> insertObjects(List<FlowNodeEntity> objects);

  @delete
  Future<void> removeObject(FlowNodeEntity object);

  Future<void> removeFlowNode(FlowNode flow) async {
    return await removeObject(toFlowNodeEntity(flow)!);
  }

  Future<int> put(FlowNode flow) async {
    return await insertObject(toFlowNodeEntity(flow)!);
  }

  Future<List<int>> putAll(List<FlowNode> objects) async {
    List<int> ids = await insertObjects(objects
        .map((object) => toFlowNodeEntity(object)!)
        .toList(growable: false));
    return ids;
  }

  FlowNode? toFlowNode(FlowNodeEntity? flowNodeEntity) {
    if (flowNodeEntity == null) {
      return null;
    }
    List<String> positions = uint8ListToStringList(flowNodeEntity.positions);
    FlowNode flowNode = FlowNode(
      flowNodeEntity.name,
      positions,
      isExpanded: flowNodeEntity.isExpanded,
    );
    flowNode.id = flowNodeEntity.autoId;
    return flowNode;
  }

  FlowNodeEntity? toFlowNodeEntity(FlowNode? flowNode) {
    if (flowNode == null) {
      return null;
    }
    Uint8List positions = stringListToUint8List(flowNode.positions);
    FlowNodeEntity flowNodeEntity = FlowNodeEntity(
      flowNode.id,
      flowNode.name,
      positions,
      isExpanded: flowNode.isExpanded,
    );
    return flowNodeEntity;
  }

  Future<List<FlowNode>> findAllFlowNodes() async {
    List<FlowNodeEntity> flowNodeEntities = await findAll();
    List<FlowNode> flowNodes = [];
    for (var flowNodeEntity in flowNodeEntities) {
      flowNodes.add(toFlowNode(flowNodeEntity)!);
    }
    return flowNodes;
  }
}
