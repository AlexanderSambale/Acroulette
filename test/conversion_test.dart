import 'dart:typed_data';

import 'package:acroulette/helper/conversion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('conversion', () {
    test('from Uint8List to List<String> and back', () {
      List<String> input = "from Uint8List to List<String> and back".split(' ');
      Uint8List uint8listInput = stringListToUint8List(input);
      expect(input, equals(uint8ListToStringList(uint8listInput)));
      expect(
        uint8listInput,
        equals(stringListToUint8List(uint8ListToStringList(uint8listInput))),
      );
    });
  });
}
