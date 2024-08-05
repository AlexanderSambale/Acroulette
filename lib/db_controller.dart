import 'package:acroulette/constants/model.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/exceptions/pair_value_exception.dart';
import 'package:acroulette/helper/node_helper.dart';
import 'package:acroulette/models/dao/flow_node_dao.dart';
import 'package:acroulette/models/dao/settings_pair_dao.dart';
import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/entities/node_entity.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/helper/import_export/import.dart';
import 'package:acroulette/models/entities/settings_pair.dart';
import 'package:acroulette/models/node.dart';
import 'helper/io/assets.dart';

class DBController {
  late final AppDatabase store;

  late final SettingsPairDao settingsBox;
  late final NodeHelper nodeBox;
  late final FlowNodeDao flowNodeBox;
  late List<String> positions;
  late List<FlowNode> flows;
  late List<SettingsPair> settings;
  late List<Node> nodesWithoutParent;

  DBController._create(this.store) {
    settingsBox = store.settingsPairDao;
    flowNodeBox = store.flowNodeDao;
    nodeBox = NodeHelper(
      store.nodeDao,
      store.nodeNodeDao,
      store.nodeWithoutParentDao,
      store,
    );
    positions = [];
    flows = [];
    settings = [];
    nodesWithoutParent = [];
  }

  Future<void> loadData() async {
    if (await nodeBox.count() == 0) {
      String data = await loadAsset('models/AcrouletteBasisNodes.json');
      await importData(data, this);
    }

    if (await flowNodeBox.count() == 0) {
      String data = await loadAsset('models/AcrouletteBasisFlows.json');
      await importData(data, this);
      await putSettingsPairValueByKey(flowIndex, '1');
    }

    await regenerateLists();
    flows = await flowNodeBox.findAllFlowNodes();
    settings = await settingsBox.findAll();

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

  Future<void> regenerateLists() async {
    List<NodeEntity> nodes = await nodeBox.findAll();
    Set<String> setOfPositions = {};
    setOfPositions.addAll(nodes
        .where((element) =>
            element.isLeaf && element.isEnabled && element.isSwitched)
        .map<String>((e) => e.label));
    positions = setOfPositions.map((e) => e).toList(growable: false);
    nodesWithoutParent = await nodeBox.findNodesWithoutParent();
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
      await settingsBox.insertObject(SettingsPair(null, key, value));
    } else {
      if (keyQueryFirstValue.value == value) return;
      keyQueryFirstValue.value = value;
      await settingsBox.updateObject(keyQueryFirstValue);
    }
    settings = await settingsBox.findAll();
  }

  Future<void> removeNode(Node node) async {
    return await nodeBox.delete(node.id);
  }

  Future<int> putFlowNode(FlowNode flow) async {
    int id = await flowNodeBox.put(flow);
    flows.add(flow);
    return id;
  }

  Future<void> removeFlowNode(FlowNode flow) async {
    if (flow.id == null) {
      throw Exception('flow id is null!');
    }
    await flowNodeBox.remove(flow.id!);
    flows.remove(flow);
  }

  bool flowExists(String label) {
    bool contains = false;
    for (var flow in flows) {
      if (flow.name == label) {
        return true;
      }
    }
    return contains;
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

  Future<int> createPosture(Node parent, String posture) async {
    // insert the posture into the db
    int id = await nodeBox.createPosture(parent, posture);
    await regenerateLists();
    return id;
  }

  Future<void> updateNodeLabel(Node node, String label) async {
    node.label = label;
    await nodeBox.updateNode(node);
    await regenerateLists();
  }

  Future<void> updateNodeIsExpanded(Node tree, bool isExpanded) async {
    tree.isExpanded = isExpanded;
    await nodeBox.updateNode(tree);
    await regenerateLists();
  }

  Future<void> deletePosture(Node child) async {
    await nodeBox.deletePosture(child);
    await regenerateLists();
  }

  Future<void> deleteCategory(Node category) async {
    await nodeBox.deleteCategory(category);
    await regenerateLists();
  }

  Future<void> createCategory(Node? parent, String category) async {
    await nodeBox.createCategory(parent, category);
    await regenerateLists();
  }

  Future<void> onSwitch(bool switched, Node tree) async {
    await nodeBox.enableOrDisable(nodeBox.toNodeEntity(tree)!, switched);
    await regenerateLists();
  }
}
