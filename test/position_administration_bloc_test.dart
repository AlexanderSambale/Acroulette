import 'dart:io';

import 'package:acroulette/bloc/position_administration/position_administration_bloc.dart';
import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:flutter_test/flutter_test.dart';

extension ToManyExtension on ToMany<Node> {
  bool containsElementWithId(int id) {
    int length = this.length;
    for (int i = 0; i < length; i++) {
      if (this[i].id == id) return true;
      if (length != this.length) {
        throw ConcurrentModificationError(this);
      }
    }
    return false;
  }
}

void main() {
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

  test('onDeleteClick', () async {
    PositionAdministrationBloc bloc = PositionAdministrationBloc(objectbox);
    Node child = objectbox.nodeBox.getAll().last;
    Node parent = objectbox.findParent(child);
    expect(parent.children.containsElementWithId(child.id), true);
    int length = parent.children.length;
    bloc.onDeleteClick(child);
    parent = objectbox.nodeBox.get(parent.id)!;
    expect(parent.children.containsElementWithId(child.id), false);
    expect(parent.children.length + 1, length);
  });
}
