import 'package:acroulette/constants/nodes.dart';
import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/models/settings_pair.dart';
import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/position.dart';

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

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  late final Box<SettingsPair> settingsBox;
  late final Box<Position> positionBox;
  late final Box<Node> nodeBox;
  late final Box<AcroNode> acroNodeBox;

  ObjectBox._create(this.store) {
    settingsBox = Box<SettingsPair>(store);
    positionBox = Box<Position>(store);
    nodeBox = Box<Node>(store);
    acroNodeBox = Box<AcroNode>(store);

    if (nodeBox.isEmpty()) {
      List<Node> children = [];
      for (var element in [
        "bird",
        "star",
        "stradle bat",
        "triangle",
        "backbird",
        "reversebird",
        "throne",
        "chair",
        "folded leaf",
        "side star",
        "vishnus couch",
        "high flying whale"
      ]) {
        AcroNode acroNode = AcroNode(true, element, predefined: true);
        acroNodeBox.put(acroNode);
        children.add(Node.createLeaf(acroNode));
      }
      AcroNode acroNodeRoot = AcroNode(true, basicPostures, predefined: true);
      acroNodeBox.put(acroNodeRoot);
      nodeBox.put(Node.createCategory(children, acroNodeRoot));
    }

    if (positionBox.isEmpty()) {
      List<Position> figures = [
        "bird",
        "star",
        "stradle bat",
        "triangle",
        "backbird",
        "reversebird",
        "throne",
        "chair",
        "folded leaf",
        "side star",
        "vishnus couch",
        "high flying whale"
      ].map<Position>((figure) => Position(figure)).toList();
      positionBox.putMany(figures);
    }
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create(Store? store) async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    if (store == null) return ObjectBox._create(await openStore());
    return ObjectBox._create(store);
  }

  String getSettingsPairValueByKey(String key) {
    Query<SettingsPair> keyQuery =
        settingsBox.query(SettingsPair_.key.equals(key)).build();
    SettingsPair? keyQueryFirstValue = keyQuery.findFirst();
    if (keyQueryFirstValue == null) {
      return key;
    } else {
      return keyQueryFirstValue.value;
    }
  }

  void putSettingsPairValueByKey(String key, String value) {
    Query<SettingsPair> keyQuery =
        settingsBox.query(SettingsPair_.key.equals(key)).build();
    SettingsPair? keyQueryFirstValue = keyQuery.findFirst();
    if (keyQueryFirstValue == null) {
      settingsBox.put(SettingsPair(key, value));
    } else {
      keyQueryFirstValue.value = value;
      settingsBox.put(keyQueryFirstValue);
    }
  }

  void putAcroNode(AcroNode acroNode) {
    acroNodeBox.put(acroNode);
  }

  void removeAcroNode(AcroNode acroNode) {
    acroNodeBox.remove(acroNode.id);
  }

  void removeManyAcroNodes(List<AcroNode> acroNodes) {
    acroNodeBox
        .removeMany(acroNodes.map<int>((element) => element.id).toList());
  }

  void putManyAcroNodes(List<AcroNode> acroNodes) {
    acroNodeBox.putMany(acroNodes);
  }

  void putNode(Node node) {
    nodeBox.put(node);
  }

  void putManyNodes(List<Node> nodes) {
    nodeBox.putMany(nodes);
  }

  void removeNode(Node node) {
    nodeBox.remove(node.id);
  }

  void removeManyNodes(List<Node> nodes) {
    nodeBox.removeMany(nodes.map<int>((element) => element.id).toList());
  }

  String? getPosition(String positionName) {
    Query<Position> keyQuery =
        positionBox.query(Position_.name.equals(positionName)).build();
    Position? keyQueryFirstValue = keyQuery.findFirst();
    if (keyQueryFirstValue == null) {
      return null;
    } else {
      return keyQueryFirstValue.name;
    }
  }

  Stream<Node> watchNodeBox() {
    final nodeBoxQuery = nodeBox.query();
    // Build and watch the query,
    // set triggerImmediately to emit the query immediately on listen.
    return nodeBoxQuery
        .watch(triggerImmediately: true)
        .map((event) => event.find().first);
  }

  Node findRoot() {
    QueryBuilder<Node> builder = nodeBox.query();
    builder.link(
        Node_.value,
        AcroNode_.predefined.equals(true) &
            AcroNode_.label.equals(basicPostures));
    Query<Node> query = builder.build();
    Node? tmpTree = query.findUnique();
    query.close();
    // Error handling ToDo
    if (tmpTree == null) {
      throw Error();
    }
    return tmpTree;
  }

  Node findParent(Node child) {
    QueryBuilder<Node> queryBuilder = nodeBox.query();
    queryBuilder.linkMany(Node_.children, Node_.id.equals(child.id));
    Node? parent = queryBuilder.build().findUnique();
    if (parent == null) throw Exception("should not be null!");
    return parent;
  }

  List<Node> getAllChildrenRecursive(Node child) {
    List<Node> allNodes = child.children.toList();
    for (var childOfChild in child.children) {
      allNodes.addAll(getAllChildrenRecursive(childOfChild));
    }
    return allNodes;
  }
}
