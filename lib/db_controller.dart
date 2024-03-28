import 'dart:io';

import 'package:acroulette/constants/model.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/exceptions/pair_value_exception.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/models/helper/import_export/import.dart';
import 'package:acroulette/models/settings_pair.dart';
import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/position.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/helper/io/assets.dart';

class DBController {
  late final Isar store;

  late final IsarCollection<SettingsPair> settingsBox;
  late final IsarCollection<Position> positionBox;
  late final IsarCollection<Node> nodeBox;
  late final IsarCollection<AcroNode> acroNodeBox;
  late final IsarCollection<FlowNode> flowNodeBox;

  DBController._create(this.store) {
    settingsBox = store.settingsPairs;
    positionBox = store.positions;
    nodeBox = store.nodes;
    acroNodeBox = store.acroNodes;
    flowNodeBox = store.flowNodes;
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
            element.acroNode.value!.isEnabled &&
            element.acroNode.value!.isSwitched)
        .map<String>((e) => e.label!));
    await store.writeTxn(() async {
      await positionBox.clear();
      await positionBox.putAll(setOfPositions.map((e) => Position(e)).toList());
    });
  }

  /// Create an instance of DBController to use throughout the app.
  static Future<DBController> create(Isar? store) async {
    DBController dbController;
    if (store == null) {
      Directory dir = await getApplicationDocumentsDirectory();
      Isar newStore = await Isar.open(
        [
          SettingsPairSchema,
          PositionSchema,
          AcroNodeSchema,
          FlowNodeSchema,
          NodeSchema,
        ],
        directory: dir.path,
      );
      dbController = DBController._create(newStore);
    } else {
      dbController = DBController._create(store);
    }
    await dbController.loadData();
    return dbController;
  }

  Future<String> getSettingsPairValueByKey(String key) async {
    SettingsPair? keyQueryFirstValue =
        await settingsBox.where().keyEqualTo(key).findFirst();
    if (keyQueryFirstValue == null) {
      throw PairValueException(
          "There is no value for the key $key in settings yet!");
    }
    return keyQueryFirstValue.value;
  }

  Future<void> putSettingsPairValueByKey(String key, String value) async {
    SettingsPair? keyQueryFirstValue =
        await settingsBox.where().keyEqualTo(key).findFirst();
    await store.writeTxn(() async {
      if (keyQueryFirstValue == null) {
        await settingsBox.put(SettingsPair(key, value));
      } else {
        if (keyQueryFirstValue.value == value) return;
        keyQueryFirstValue.value = value;
        await settingsBox.put(keyQueryFirstValue);
      }
    });
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

  Future<bool> removeFlowNode(FlowNode flow) async {
    return await flowNodeBox.delete(flow.id);
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

  Future<List<Node>> findNodesWithoutParent() async {
    List<Node> nodesWithoutParent =
        await nodeBox.filter().parentIsNull().findAll();
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
    FlowNode? first = await flowNodeBox.where().nameEqualTo(label).findFirst();
    return first == null ? false : true;
  }

  Future<List<String>> flowPositions() async {
    FlowNode? flow = await flowNodeBox
        .get(int.parse(await getSettingsPairValueByKey(flowIndex)));
    if (flow == null) {
      return [];
    } else {
      return flow.positions;
    }
  }

  Future<List<String>> possiblePositions() async {
    List<Position> positions = await positionBox.where().findAll();
    return positions.map<String>((element) => element.name).toList();
  }
}
