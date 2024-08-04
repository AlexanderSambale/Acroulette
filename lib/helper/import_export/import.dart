import 'dart:convert';
import 'dart:io';

import 'package:acroulette/constants/import_export.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/db_controller.dart';
import 'package:acroulette/models/node.dart';
import 'package:pick_or_save/pick_or_save.dart';

void import(DBController dbController) async {
  List<String>? result = await PickOrSave().filePicker(
    params: FilePickerParams(),
  );
  String filePath = result![0];
  File file = File(filePath);
  String content = await file.readAsString();
  await importData(content, dbController);
}

Future<void> importData(String data, DBController dbController) async {
  Map decoded = jsonDecode(data);
  if (decoded[flowsKey] != null) {
    List<FlowNode> flows = [];
    for (Map flow in decoded[flowsKey]) {
      flows.add(FlowNode.createFromMap(flow));
    }
    await dbController.flowNodeBox.putAll(flows);
  }
  if (decoded[nodesKey] != null) {
    List<Node> nodes = Node.createFromListOfMaps(decoded[nodesKey]);
    await dbController.nodeBox.insertTrees(nodes);
  }
}
