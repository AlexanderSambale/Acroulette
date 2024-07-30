import 'dart:io';

import 'package:acroulette/helper/conversion.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/helper/import_export/import.dart';
import 'package:acroulette/helper/io/assets.dart';
import 'package:acroulette/db_controller.dart';
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

    late Isar store;
    late DBController dbController;

    final dir = Directory('import_test');
    setUp(() async {
      if (dir.existsSync()) dir.deleteSync(recursive: true);
      await dir.create();
      store = await Isar.open(
        [
          SettingsPairSchema,
          PositionSchema,
          AcroNodeSchema,
          FlowNodeSchema,
          NodeSchema,
        ],
        directory: dir.path,
      );
      dbController = await DBController.create(store);
    });

    tearDown(() {
      store.close();
      if (dir.existsSync()) dir.deleteSync(recursive: true);
    });

    test('import basic nodes', () {
      loadAsset('models/AcrouletteBasisNodes.json').then((data) {
        importData(data, dbController);
        expect(dbController.nodeBox.countSync() == 0, false);
      });
    });

    test('import basic flows', () {
      loadAsset('models/AcrouletteBasisFlows.json').then((data) {
        importData(data, dbController);
        expect(dbController.flowNodeBox.countSync() == 0, false);
      });
    });
  });
}
