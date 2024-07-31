import 'dart:typed_data';

import 'package:acroulette/helper/conversion.dart';
import 'package:acroulette/models/entities/flow_node_entity.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:floor/floor.dart';

@dao
abstract class FlowNodeDao {
  @Query('SELECT last_insert_rowid()')
  Future<int?> incrementedId();

  @Query('SELECT COUNT(*) FROM FlowNodeEntity')
  Future<int?> count();

  @Query('DELETE FROM FlowNodeEntity WHERE autoId = :id')
  Future<void> remove(int id);

  @Query('SELECT * FROM FlowNodeEntity WHERE name = :name')
  Future<FlowNodeEntity?> findEntityByName(String name);

  Future<FlowNode?> findByName(String name) async {
    return toFlowNode(await findEntityByName(name));
  }

  @Query('SELECT * FROM FlowNodeEntity WHERE autoId = :id')
  Future<FlowNodeEntity?> findEntityById(int id);

  Future<FlowNode?> findById(int id) async {
    return toFlowNode(await findEntityById(id));
  }

  @insert
  Future<void> insertObject(FlowNodeEntity object);

  @delete
  Future<void> removeObject(FlowNodeEntity object);

  Future<void> removeFlowNode(FlowNode flow) async {
    return await removeObject(toFlowNodeEntity(flow)!);
  }

  Future<int> put(FlowNode flow) async {
    return await insertFlowNode(toFlowNodeEntity(flow)!);
  }

  Future<int> insertFlowNode(FlowNodeEntity object) async {
    await insertObject(object);
    int? id = await incrementedId();
    if (id == null) {
      throw Exception('Id is null after put');
    }
    return id;
  }

  Future<List<int>> insertFlowNodes(List<FlowNodeEntity> objects) async {
    List<int> ids = [];
    for (var object in objects) {
      ids.add(await insertFlowNode(object));
    }
    return ids;
  }

  Future<List<int>> putAll(List<FlowNode> objects) async {
    List<int> ids = [];
    for (var object in objects) {
      ids.add(await put(object));
    }
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
}
