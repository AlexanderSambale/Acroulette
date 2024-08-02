import 'package:acroulette/constants/model.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/exceptions/pair_value_exception.dart';
import 'package:acroulette/helper/node_helper.dart';
import 'package:acroulette/models/dao/flow_node_dao.dart';
import 'package:acroulette/models/dao/settings_pair_dao.dart';
import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/helper/import_export/import.dart';
import 'package:acroulette/models/entities/settings_pair.dart';
import 'package:acroulette/models/node.dart';
import 'helper/io/assets.dart';

class DBController {
  late final AppDatabase store;

  late final SettingsPairDao settingsBox;
  late List<String> positions;
  late final NodeHelper nodeBox;
  late final FlowNodeDao flowNodeBox;

  DBController._create(this.store) {
    settingsBox = store.settingsPairDao;
    flowNodeBox = store.flowNodeDao;
    nodeBox = NodeHelper(store.nodeDao, store.nodeNodeDao);
    positions = [];
  }

  Future<void> loadData() async {
    if (await nodeBox.count() == 0) {
      loadAsset('models/AcrouletteBasisNodes.json').then((data) async {
        importData(data, this);
        positions = await regeneratePositionsList();
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

  Future<List<String>> regeneratePositionsList() async {
    List<Node> nodes = await nodeBox.findAll();
    Set<String> setOfPositions = {};
    setOfPositions.addAll(nodes
        .where((element) =>
            element.isLeaf && element.isEnabled && element.isSwitched)
        .map<String>((e) => e.label));
    return setOfPositions.map((e) => e).toList();
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

  Future<int> putNode(Node node) async {
    return await nodeBox.put(node);
  }

  Future<List<int>> putManyNodes(List<Node> nodes) async {
    return await nodeBox.putAll(nodes);
  }

  Future<void> removeNode(Node node) async {
    return await nodeBox.delete(node.id);
  }

  Future<void> removeManyNodes(List<Node> nodes) async {
    return await nodeBox
        .deleteAll(nodes.map<int?>((element) => element.id).toList());
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

  Future<List<Node>> findNodesWithoutParent() async {
    List<Node> nodesWithoutParent = await nodeBox.findNodesWithoutParent();
    return nodesWithoutParent;
  }

  Node? findParent(Node child) {
    return child.parent;
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

  Future<void> createPosture(Node parent, String posture) async {
    AcroNode acroNode = AcroNode(true, posture);
    Node newPosture = Node.createLeaf(parent: parent, acroNode);
    parent.addNode(newPosture);
    putNode(parent);
    regeneratePositionsList();
  }

  Future<void> updateNodeLabel(Node node, String label) async {
    dbController.putNode(parent);
    regeneratePositionsList();
  }

  Future<void> deletePosture(Node child) async {
    Node? parent = dbController.findParent(child);
    if (parent != null) {
      parent.children.remove(child);
      dbController.putNode(parent);
    }
    dbController.removeNode(child);
    regeneratePositionsList();
  }

  Future<void> deleteCategory(Node category) async {
    List<Node> toRemove = dbController.getAllChildrenRecursive(category)
      ..add(category);
    Node? parent = dbController.findParent(category);
    if (parent != null) {
      parent.children.remove(category);
      dbController.putNode(parent);
    }
    dbController.removeManyNodes(toRemove);
    regeneratePositionsList();
  }

  Future<void> createCategory(Node? parent, String category) async {
    AcroNode acroNode = AcroNode(true, category);
    Node newPosture = Node.optional(parent: parent, [], acroNode);
    if (parent != null) {
      parent.addNode(newPosture);
      dbController.putNode(parent);
    } else {
      dbController.putNode(newPosture);
    }
    regeneratePositionsList();
  }

  /// Depending on [isSwitched] we enable or disable recursive [acroNodes] from
  /// this [tree].
  ///
  /// Here is a table, what to do in which case.
  ///
  /// state | toEnable | toDisable
  /// ----|----|----
  /// enabled switch on| /| disabled on, disable others
  /// disable switch on| enable on, enable others| /
  /// enabled switch off| /| disable off, nothing else
  /// disable switch off| enable off, nothing else|/
  Future<void> enableOrDisable(
    Node tree,
    bool isSwitched,
  ) async {
    for (var node in tree.children) {
      if (node.isSwitched) {
        enableOrDisable(node, isSwitched);
      }
      node.isEnabled = isSwitched;
      // update node
    }
  }

  Future<void> onSwitch(bool switched, Node tree) async {
    tree.isSwitched = switched;
    enableOrDisable(tree, switched);
    dbController.putNode(tree);
    regeneratePositionsList();
  }
}
