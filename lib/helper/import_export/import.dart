import 'dart:convert';
import 'dart:io';

import 'package:acroulette/constants/import_export.dart';
import 'package:acroulette/domain_layer/flow_node_repository.dart';
import 'package:acroulette/domain_layer/node_repository.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:pick_or_save/pick_or_save.dart';

void import(
  NodeRepository nodeRepository,
  FlowNodeRepository flowNodeRepository,
) async {
  List<String>? result = await PickOrSave().filePicker(
    params: FilePickerParams(),
  );
  String filePath = result![0];
  File file = File(filePath);
  String content = await file.readAsString();
  await importNodes(
    content,
    nodeRepository,
  );
  await importFlowNodes(
    content,
    flowNodeRepository,
  );
}

Future<void> importFlowNodes(
  String data,
  FlowNodeRepository flowNodeRepository,
) async {
  Map decoded = jsonDecode(data);
  if (decoded[flowsKey] != null) {
    List<FlowNode> flows = [];
    for (Map flow in decoded[flowsKey]) {
      flows.add(FlowNode.createFromMap(flow));
    }
    await flowNodeRepository.putAll(flows);
  }
}

Future<void> importNodes(
  String data,
  NodeRepository nodeRepository,
) async {
  Map decoded = jsonDecode(data);
  if (decoded[nodesKey] != null) {
    List<Node> nodes = Node.createFromListOfMaps(decoded[nodesKey]);
    await nodeRepository.insertTrees(nodes);
  }
}
