import 'package:acroulette/helper/conversion.dart';
import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/helper/import_export/import.dart';
import 'package:acroulette/helper/io/assets.dart';
import 'package:acroulette/storage_provider.dart';
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

    late AppDatabase database;
    late StorageProvider storageProvider;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
      storageProvider = await StorageProvider.create(database);
    });

    tearDown(() async {
      await database.close();
    });

    test('import basic nodes', () async {
      String data = await loadAsset('models/AcrouletteBasisNodes.json');
      await importData(data, storageProvider);
      int? actual = await storageProvider.nodeBox.count();
      expect(actual, isNot(0));
    });

    test('import basic flows', () async {
      String data = await loadAsset('models/AcrouletteBasisFlows.json');
      await importData(data, storageProvider);
      int? actual = await storageProvider.flowNodeBox.count();
      expect(actual, isNot(0));
    });
  });
}
