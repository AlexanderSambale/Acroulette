import 'dart:typed_data';

import 'package:acroulette/constants/import_export.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:pick_or_save/pick_or_save.dart';

void export(ObjectBox objectBox) async {
  Uint8List uint8List = getData(objectBox);
  await PickOrSave().fileSaver(
      params: FileSaverParams(
    saveFiles: [
      SaveFileInfo(fileData: uint8List, fileName: "AcrouletteExport"),
    ],
  ));
}

Uint8List getData(ObjectBox objectBox) {
  String result = '''{
  "$nodesKey": ${objectBox.findNodesWithoutParent().toString()},
  "$flowsKey": ${objectBox.flowNodeBox.getAll().toString()}
}''';
  return convertStringToUint8List(result);
}

Uint8List convertStringToUint8List(String str) {
  final List<int> codeUnits = str.codeUnits;
  final Uint8List unit8List = Uint8List.fromList(codeUnits);

  return unit8List;
}
