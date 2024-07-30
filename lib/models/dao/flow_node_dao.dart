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

  @insert
  Future<void> insertObject(FlowNodeEntity object);

  @delete
  Future<void> removeObject(FlowNodeEntity object);

  Future<int> remove(FlowNodeEntity object) async {
    await removeObject(object);
    return object.id;
  }

  Future<int> put(FlowNodeEntity object) async {
    await insertObject(object);
    int? id = await incrementedId();
    if (id == null) {
      throw Exception('Id is null after put');
    }
    return id;
  }

  Future<List<int>> putAll(List<FlowNodeEntity> objects) async {
    List<int> ids = [];
    for (var object in objects) {
      ids.add(await put(object));
    }
    return ids;
  }

  FlowNode toFlowNode(FlowNodeEntity flowNodeEntity) {
    List<String> positions = uint8ListToStringList(flowNodeEntity.positions);
    FlowNode flowNode = FlowNode(
      flowNodeEntity.name,
      positions,
      isExpanded: flowNodeEntity.isExpanded,
    );
    return flowNode;
  }

  FlowNodeEntity toFlowNodeEntity(FlowNode flowNode) {
    Uint8List positions = stringListToUint8List(flowNode.positions);
    FlowNodeEntity flowNodeEntity = FlowNodeEntity(
      flowNode.name,
      positions,
      isExpanded: flowNode.isExpanded,
    );
    return flowNodeEntity;
  }
}
