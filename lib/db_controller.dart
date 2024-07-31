import 'package:acroulette/constants/model.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/exceptions/pair_value_exception.dart';
import 'package:acroulette/models/dao/acro_node_dao.dart';
import 'package:acroulette/models/dao/flow_node_dao.dart';
import 'package:acroulette/models/dao/node_dao.dart';
import 'package:acroulette/models/dao/position_dao.dart';
import 'package:acroulette/models/dao/settings_pair_dao.dart';
import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/helper/import_export/import.dart';
import 'package:acroulette/models/entities/settings_pair.dart';
import 'package:acroulette/models/entities/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/entities/position.dart';
import 'helper/io/assets.dart';

class DBController {
  late final AppDatabase store;

  late final SettingsPairDao settingsBox;
  late final PositionDao positionBox;
  late final NodeDao nodeBox;
  late final AcroNodeDao acroNodeBox;
  late final FlowNodeDao flowNodeBox;

  DBController._create(this.store) {
    settingsBox = store.settingsPairDao;
    positionBox = store.positionDao;
    nodeBox = store.nodeDao;
    acroNodeBox = store.acroNodeDao;
    flowNodeBox = store.flowNodeDao;
  }

  Future<void> loadData() async {
    if (await nodeBox.count() == 0) {
      loadAsset('models/AcrouletteBasisNodes.json').then((data) {
        importData(data, this);
        regeneratePositionsList();
      });
    }

    if (await flowNodeBox.count() == 0) {
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

  void setDefaultValue(String key, String value) async {
    try {
      await getSettingsPairValueByKey(key);
    } on PairValueException {
      await putSettingsPairValueByKey(key, value);
    }
  }

  Future<void> regeneratePositionsList() async {
    List<Node> nodes = await nodeBox.where().findAll();
    Set<String> setOfPositions = {};
    setOfPositions.addAll(nodes
        .where((element) =>
            element.isLeaf &&
            element.acroNode.isEnabled &&
            element.acroNode.isSwitched)
        .map<String>((e) => e.label!));
    await store.writeTxn(() async {
      await positionBox.clear();
      await positionBox.putAll(setOfPositions.map((e) => Position(e)).toList());
    });
  }

  /// Create an instance of DBController to use throughout the app.
  static Future<DBController> create(AppDatabase? store) async {
    DBController dbController;
    if (store == null) {
      AppDatabase newStore =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      dbController = DBController._create(newStore);
    } else {
      dbController = DBController._create(store);
    }
    await dbController.loadData();
    return dbController;
  }

  Future<String> getSettingsPairValueByKey(String key) async {
    SettingsPair? keyQueryFirstValue = await settingsBox.findEntityByKey(key);
    if (keyQueryFirstValue == null) {
      throw PairValueException(
          "There is no value for the key $key in settings yet!");
    }
    return keyQueryFirstValue.value;
  }

  Future<void> putSettingsPairValueByKey(String key, String value) async {
    SettingsPair? keyQueryFirstValue = await settingsBox.findEntityByKey(key);
    if (keyQueryFirstValue == null) {
      await settingsBox.put(SettingsPair(null, key, value));
    } else {
      if (keyQueryFirstValue.value == value) return;
      keyQueryFirstValue.value = value;
      await settingsBox.updateObject(keyQueryFirstValue);
    }
  }

  Future<int> putAcroNode(AcroNode acroNode) async {
    return await acroNodeBox.put(acroNode);
  }

  Future<bool> removeAcroNode(AcroNode acroNode) async {
    return await acroNodeBox.delete(acroNode.id);
  }

  Future<int> removeManyAcroNodes(List<AcroNode> acroNodes) async {
    return await acroNodeBox
        .deleteAll(acroNodes.map<int>((element) => element.id).toList());
  }

  Future<List<int>> putManyAcroNodes(List<AcroNode> acroNodes) async {
    return await acroNodeBox.putAll(acroNodes);
  }

  Future<int> putNode(Node node) async {
    return await nodeBox.put(node);
  }

  Future<List<int>> putManyNodes(List<Node> nodes) async {
    return await nodeBox.putAll(nodes);
  }

  Future<bool> removeNode(Node node) async {
    return await nodeBox.delete(node.id);
  }

  Future<int> removeManyNodes(List<Node> nodes) async {
    return await nodeBox
        .deleteAll(nodes.map<int>((element) => element.id).toList());
  }

  Future<int> putFlowNode(FlowNode flow) async {
    return await flowNodeBox.put(flow);
  }

  Future<void> removeFlowNode(FlowNode flow) async {
    if (flow.id == null) {
      throw Exception('flow id is null!');
    }
    return await flowNodeBox.remove(flow.id!);
  }

  Future<String?> getPosition(String positionName) async {
    Position? positionQueryFirstValue =
        await positionBox.where().nameEqualTo(positionName).findFirst();
    if (positionQueryFirstValue == null) {
      return null;
    } else {
      return positionQueryFirstValue.name;
    }
  }

  List<Node> findNodesWithoutParent() {
    List<Node> nodesWithoutParent =
        nodeBox.filter().parentIsNull().findAllSync();
    return nodesWithoutParent;
  }

  Node? findParent(Node child) {
    return child.parent.value;
  }

  List<Node> getAllChildrenRecursive(Node child) {
    List<Node> allNodes = child.children.toList();
    for (var childOfChild in child.children) {
      allNodes.addAll(getAllChildrenRecursive(childOfChild));
    }
    return allNodes;
  }

  Future<bool> flowExists(String label) async {
    FlowNode? first = await flowNodeBox.findByName(label);
    return first == null ? false : true;
  }

  Future<List<String>> flowPositions() async {
    FlowNode? flow = await flowNodeBox
        .findById(int.parse(await getSettingsPairValueByKey(flowIndex)));
    if (flow == null) {
      return [];
    } else {
      return flow.positions;
    }
  }

  List<String> possiblePositions() {
    List<Position> positions = positionBox.where().findAllSync();
    return positions.map<String>((element) => element.name).toList();
  }
}
