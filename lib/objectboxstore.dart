import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/models/SettingsPair.dart';
import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/position.dart';

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
      ToMany<Node> children = ToMany<Node>();
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
        ToOne<AcroNode> acroNode = ToOne<AcroNode>();
        acroNode.target = AcroNode(true, element);
        acroNodeBox.put(acroNode.target!);
        children.add(Node.createLeaf(acroNode));
      }
      ToOne<AcroNode> acroNodeRoot = ToOne<AcroNode>();
      acroNodeRoot.target = AcroNode(true, 'Basic postures');
      acroNodeBox.put(acroNodeRoot.target!);
      nodeBox.put(Node(children, acroNodeRoot));
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
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
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

  void putManyAcroNodes(List<AcroNode> acroNodes) {
    acroNodeBox.putMany(acroNodes);
  }

  void putNode(Node node) {
    nodeBox.put(node);
  }

  void putManyNodes(List<Node> nodes) {
    nodeBox.putMany(nodes);
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
}
