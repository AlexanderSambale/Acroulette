import 'package:acroulette/constants/nodes.dart';
import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/db_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;
  late DBController dbController;

  setUp(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    dbController = await DBController.create(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('findParent', () {
    Node parent = dbController.findParent(dbController.nodeBox.findAll());
    expect(parent.isExpanded, true);
    expect(parent.label, basicPostures);
  });
}
