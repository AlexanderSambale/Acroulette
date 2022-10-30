import 'package:acroulette/models/node.dart';
import 'package:objectbox/objectbox.dart';

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

  bool containsElementWithLabel(bool isPosture, String label) {
    int length = this.length;
    for (int i = 0; i < length; i++) {
      if (this[i].isLeaf == isPosture && this[i].label! == label) return true;
      if (length != this.length) {
        throw ConcurrentModificationError(this);
      }
    }
    return false;
  }
}
