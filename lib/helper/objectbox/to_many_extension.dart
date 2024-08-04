import 'package:acroulette/models/node.dart';

extension Children on List<Node> {
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
