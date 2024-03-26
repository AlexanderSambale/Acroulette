import 'dart:io';

import 'package:acroulette/constants/nodes.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/db_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Store store;
  late DBController dbController;
  final dir = Directory('testdata');

  setUp(() async {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
    await dir.create();
    store = await openStore(directory: dir.path);
    dbController = await DBController.create(store);
  });

  tearDown(() {
    store.close();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  test('findParent', () {
    Node parent = dbController.findParent(dbController.nodeBox.getAll().last)!;
    expect(parent.isExpanded, true);
    expect(parent.label!, basicPostures);
  });
}
