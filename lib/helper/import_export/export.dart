import 'dart:typed_data';

import 'package:acroulette/constants/import_export.dart';
import 'package:acroulette/db_controller.dart';
import 'package:acroulette/helper/conversion.dart';
import 'package:pick_or_save/pick_or_save.dart';

void export(DBController dbController) async {
  Uint8List uint8List = getData(dbController);
  await PickOrSave().fileSaver(
      params: FileSaverParams(
    saveFiles: [
      SaveFileInfo(fileData: uint8List, fileName: "AcrouletteExport"),
    ],
  ));
}

Uint8List getData(DBController dbController) {
  String result = '''{
  "$nodesKey": ${dbController.findNodesWithoutParent().toString()},
  "$flowsKey": ${dbController.flowNodeBox.findAllFlowNodes().toString()}
}''';
  return convertStringToUint8List(result);
}
