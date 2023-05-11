import 'dart:typed_data';

import 'package:pick_or_save/pick_or_save.dart';

void export() async {
  Uint8List uint8List = getData();
  await PickOrSave().fileSaver(
      params: FileSaverParams(
    saveFiles: [
      SaveFileInfo(fileData: uint8List),
    ],
  ));
}

Uint8List getData() {
  Uint8List result;
  return result;
}

Uint8List convertStringToUint8List(String str) {
  final List<int> codeUnits = str.codeUnits;
  final Uint8List unit8List = Uint8List.fromList(codeUnits);

  return unit8List;
}
