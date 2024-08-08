import 'dart:typed_data';

import 'package:acroulette/constants/import_export.dart';
import 'package:acroulette/storage_provider.dart';
import 'package:acroulette/helper/conversion.dart';
import 'package:pick_or_save/pick_or_save.dart';

void export(StorageProvider storageProvider) async {
  Uint8List uint8List = getData(storageProvider);
  await PickOrSave().fileSaver(
      params: FileSaverParams(
    saveFiles: [
      SaveFileInfo(fileData: uint8List, fileName: "AcrouletteExport"),
    ],
  ));
}

Uint8List getData(StorageProvider storageProvider) {
  String result = '''{
  "$nodesKey": ${storageProvider.nodesWithoutParent.toString()},
  "$flowsKey": ${storageProvider.flowNodeBox.findAllFlowNodes().toString()}
}''';
  return convertStringToUint8List(result);
}
