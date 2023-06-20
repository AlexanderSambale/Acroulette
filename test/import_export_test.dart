import 'dart:io';

import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/models/helper/import_export/export.dart';
import 'package:acroulette/models/helper/import_export/import.dart';
import 'package:acroulette/models/helper/io/assets.dart';
import 'package:acroulette/objectboxstore.dart';
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

  group('import', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    late Store store;
    late ObjectBox objectbox;

    final dir = Directory('import_test');
    setUp(() async {
      if (dir.existsSync()) dir.deleteSync(recursive: true);
      await dir.create();
      store = await openStore(directory: dir.path);
      objectbox = await ObjectBox.create(store);
    });

    tearDown(() {
      store.close();
      if (dir.existsSync()) dir.deleteSync(recursive: true);
    });

    test('import basic nodes', () {
      loadAsset('models/AcrouletteBasisNodes.json').then((data) {
        importData(data, objectbox);
        expect(objectbox.nodeBox.isEmpty(), false);
      });
    });

    test('import basic flows', () {
      loadAsset('models/AcrouletteBasisFlows.json').then((data) {
        importData(data, objectbox);
        expect(objectbox.flowNodeBox.isEmpty(), false);
      });
    });
  });
}
