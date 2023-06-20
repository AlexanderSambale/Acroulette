import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:acroulette/constants/import_export.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:pick_or_save/pick_or_save.dart';

void import(ObjectBox objectBox) async {
  List<String>? result = await PickOrSave().filePicker(
    params: FilePickerParams(),
  );
  String filePath = result![0];
  File file = File(filePath);
  String content = await file.readAsString();
  importData(content, objectBox);
}

String convertUint8ListToString(Uint8List uint8list) {
  return String.fromCharCodes(uint8list);
}

void importData(String data, ObjectBox objectBox) {
  Map decoded = jsonDecode(data);
  if (decoded[flowsKey] != null) {
    List<FlowNode> flows = [];
    for (Map flow in decoded[flowsKey]) {
      flows.add(FlowNode.createFromMap(flow));
    }
    objectBox.flowNodeBox.putMany(flows);
  }
  if (decoded[nodesKey] != null) {
    objectBox.nodeBox.putMany(Node.createFromListOfMaps(decoded[nodesKey]));
  }
}
