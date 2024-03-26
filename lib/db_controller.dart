import 'package:acroulette/constants/model.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/exceptions/pair_value_exception.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/models/helper/import_export/import.dart';
import 'package:acroulette/models/settings_pair.dart';
import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/position.dart';
import 'models/helper/io/assets.dart';

class DBController {
  /// The Store of this app.
  late final Store store;

  late final Box<SettingsPair> settingsBox;
  late final Box<Position> positionBox;
  late final Box<Node> nodeBox;
  late final Box<AcroNode> acroNodeBox;
  late final Box<FlowNode> flowNodeBox;

  DBController._create(this.store) {
    settingsBox = Box<SettingsPair>(store);
    positionBox = Box<Position>(store);
    nodeBox = Box<Node>(store);
    acroNodeBox = Box<AcroNode>(store);
    flowNodeBox = Box<FlowNode>(store);

    if (nodeBox.isEmpty()) {
      loadAsset('models/AcrouletteBasisNodes.json').then((data) {
        importData(data, this);
        regeneratePositionsList();
      });
    }

    if (flowNodeBox.isEmpty()) {
      loadAsset('models/AcrouletteBasisFlows.json').then((data) {
        importData(data, this);
        putSettingsPairValueByKey(flowIndex, '1');
      });
    }

    setDefaultValue(appMode, acroulette);

    // voice recognition
    setDefaultValue(newPosition, newPosition);
    setDefaultValue(nextPosition, nextPosition);
    setDefaultValue(previousPosition, previousPosition);
    setDefaultValue(currentPosition, currentPosition);

    // text to speech
    setDefaultValue(rateKey, "0.5");
    setDefaultValue(pitchKey, "0.5");
    setDefaultValue(volumeKey, "0.5");
    setDefaultValue(languageKey, "en-US");
    setDefaultValue(engineKey, "com.google.android.tts");
    setDefaultValue(playingKey, "false");
  }

  void setDefaultValue(String key, String value) {
    try {
      getSettingsPairValueByKey(key);
    } on PairValueException {
      putSettingsPairValueByKey(key, value);
    }
  }

  void regeneratePositionsList() {
    List<Node> nodes = nodeBox.getAll();
    Set<String> setOfPositions = {};
    setOfPositions.addAll(nodes
        .where((element) =>
            element.isLeaf &&
            element.value.target!.isEnabled &&
            element.value.target!.isSwitched)
        .map<String>((e) => e.label!));
    positionBox.removeAll();
    positionBox.putMany(setOfPositions.map((e) => Position(e)).toList());
  }

  /// Create an instance of DBController to use throughout the app.
  static Future<DBController> create(Store? store) async {
    if (store == null) return DBController._create(await openStore());
    return DBController._create(store);
  }

  String getSettingsPairValueByKey(String key) {
    Query<SettingsPair> keyQuery =
        settingsBox.query(SettingsPair_.key.equals(key)).build();
    SettingsPair? keyQueryFirstValue = keyQuery.findFirst();
    if (keyQueryFirstValue == null) {
      throw PairValueException(
          "There is no value for the key $key in settings yet!");
    }
    return keyQueryFirstValue.value;
  }

  void putSettingsPairValueByKey(String key, String value) {
    Query<SettingsPair> keyQuery =
        settingsBox.query(SettingsPair_.key.equals(key)).build();
    SettingsPair? keyQueryFirstValue = keyQuery.findFirst();
    if (keyQueryFirstValue == null) {
      settingsBox.put(SettingsPair(key, value));
    } else {
      if (keyQueryFirstValue.value == value) return;
      keyQueryFirstValue.value = value;
      settingsBox.put(keyQueryFirstValue);
    }
  }

  int putAcroNode(AcroNode acroNode) {
    return acroNodeBox.put(acroNode);
  }

  bool removeAcroNode(AcroNode acroNode) {
    return acroNodeBox.remove(acroNode.id);
  }

  int removeManyAcroNodes(List<AcroNode> acroNodes) {
    return acroNodeBox
        .removeMany(acroNodes.map<int>((element) => element.id).toList());
  }

  List<int> putManyAcroNodes(List<AcroNode> acroNodes) {
    return acroNodeBox.putMany(acroNodes);
  }

  int putNode(Node node) {
    return nodeBox.put(node);
  }

  List<int> putManyNodes(List<Node> nodes) {
    return nodeBox.putMany(nodes);
  }

  bool removeNode(Node node) {
    return nodeBox.remove(node.id);
  }

  int removeManyNodes(List<Node> nodes) {
    return nodeBox.removeMany(nodes.map<int>((element) => element.id).toList());
  }

  int putFlowNode(FlowNode flow) {
    return flowNodeBox.put(flow);
  }

  bool removeFlowNode(FlowNode flow) {
    return flowNodeBox.remove(flow.id);
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

  List<Node> findNodesWithoutParent() {
    QueryBuilder<Node> queryBuilder = nodeBox.query(Node_.parent.equals(0));
    Query<Node> query = queryBuilder.build();
    return query.find();
  }

  Node? findParent(Node child) {
    return child.parent.target;
  }

  List<Node> getAllChildrenRecursive(Node child) {
    List<Node> allNodes = child.children.toList();
    for (var childOfChild in child.children) {
      allNodes.addAll(getAllChildrenRecursive(childOfChild));
    }
    return allNodes;
  }

  bool flowExists(String label) {
    FlowNode? first =
        flowNodeBox.query(FlowNode_.name.equals(label)).build().findFirst();
    return first == null ? false : true;
  }

  List<String> flowPositions() {
    return flowNodeBox
        .get(int.parse(getSettingsPairValueByKey(flowIndex)))!
        .positions;
  }

  List<String> possiblePositions() {
    return positionBox.getAll().map<String>((element) => element.name).toList();
  }
}
