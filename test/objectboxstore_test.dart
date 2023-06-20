import 'dart:io';

import 'package:acroulette/constants/nodes.dart';
import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Store store;
  late ObjectBox objectbox;
  final dir = Directory('testdata');

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

  test('findParent', () {
    Node parent = objectbox.findParent(objectbox.nodeBox.getAll().last)!;
    expect(parent.isExpanded, true);
    expect(parent.label!, basicPostures);
  });
}
