import 'dart:typed_data';

import 'package:pick_or_save/pick_or_save.dart';

void import() async {
  List<String>? result = await PickOrSave().filePicker(
    params: FilePickerParams(getCachedFilePath: false),
  );
  String filePath = result![0];
  // data = readFile(filePath);
  // importData(data);
}

String convertUint8ListToString(Uint8List uint8list) {
  return String.fromCharCodes(uint8list);
}
