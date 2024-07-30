import 'package:acroulette/models/entities/node_entity.dart';
import 'package:isar/isar.dart';

extension ToManyExtension on IsarLinks<Node> {
  bool containsElementWithId(int id) {
    var links = where((element) => element.id == id);
    return links.isNotEmpty;
  }

  bool containsElementWithLabel(bool isPosture, String label) {
    var links = where(
        (element) => element.isLeaf == isPosture && element.label == label);
    return links.isNotEmpty;
  }
}
