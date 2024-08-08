import 'dart:typed_data';

import 'package:acroulette/constants/import_export.dart';
import 'package:acroulette/domain_layer/flow_node_repository.dart';
import 'package:acroulette/domain_layer/node_repository.dart';
import 'package:acroulette/helper/conversion.dart';
import 'package:pick_or_save/pick_or_save.dart';

void export(
  NodeRepository nodeRepository,
  FlowNodeRepository flowNodeRepository,
) async {
  Uint8List uint8List = getData(
    nodeRepository,
    flowNodeRepository,
  );
  await PickOrSave().fileSaver(
      params: FileSaverParams(
    saveFiles: [
      SaveFileInfo(fileData: uint8List, fileName: "AcrouletteExport"),
    ],
  ));
}

Uint8List getData(
  NodeRepository nodeRepository,
  FlowNodeRepository flowNodeRepository,
) {
  String result = '''{
  "$nodesKey": ${nodeRepository.nodesWithoutParent.toString()},
  "$flowsKey": ${flowNodeRepository.flows.toString()}
}''';
  return convertStringToUint8List(result);
}
