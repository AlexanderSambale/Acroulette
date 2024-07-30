import 'dart:typed_data';

// combination of uncommon symbols
String joinString = '\u{1D434}\u{26A1}\u{1D4FD}';

Uint8List stringListToUint8List(List<String> input) {
  List<int> lowIntegerBytes = [];
  Uint16List uint16List = Uint16List.fromList(input.join(joinString).codeUnits);
  for (var u16integer in uint16List) {
    lowIntegerBytes.add(getIntHighByte(u16integer));
    lowIntegerBytes.add(getIntLowByte(u16integer));
  }
  Uint8List result = Uint8List.fromList(lowIntegerBytes);
  return result;
}

List<String> uint8ListToStringList(Uint8List uint8List) {
  List<int> lowIntegerBytes = uint8List.toList();
  List<int> charCodes = [];
  int lowByte = 0;
  int highByte = 0;
  int u16integer = 0;
  bool odd = true;
  for (int integer in lowIntegerBytes) {
    if (odd) {
      highByte = integer << 8;
      odd = false;
    } else {
      lowByte = integer;
      u16integer = highByte | lowByte;
      charCodes.add(u16integer);
      odd = true;
    }
  }
  List<String> resultList = String.fromCharCodes(charCodes).split(joinString);
  return resultList;
}

int getIntHighByte(int input) {
  return (input >> 8) & 0xFF;
}

int getIntLowByte(int input) {
  return input & 0xFF;
}
