import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/models/helper/import_export/export.dart';
import 'package:acroulette/models/helper/import_export/import.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('convert Uint8List', () {
    var exportStr = FlowNode('ninja star', [
      'ninja side star',
      'reverse bird',
      'ninja side star',
      'buddha'
    ]).toString();
    expect(convertUint8ListToString(convertStringToUint8List(exportStr)),
        exportStr);
  });
}
