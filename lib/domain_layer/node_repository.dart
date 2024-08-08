import 'package:acroulette/helper/import_export/import.dart';
import 'package:acroulette/helper/io/assets.dart';
import 'package:acroulette/models/entities/node_entity.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/storage_provider.dart';

class NodeRepository {
  final StorageProvider storageProvider;
  List<Node> nodesWithoutParent = [];
  List<String> positions = [];

  NodeRepository(this.storageProvider);

  Future<void> initialize() async {
    if (await storageProvider.nodeBox.count() == 0) {
      String data = await loadAsset('models/AcrouletteBasisNodes.json');
      await importData(data, storageProvider);
    }
    await regenerateLists();
  }

  Future<void> regenerateLists() async {
    List<NodeEntity> nodes = await storageProvider.nodeBox.findAll();
    Set<String> setOfPositions = {};
    setOfPositions.addAll(nodes
        .where((element) =>
            element.isLeaf && element.isEnabled && element.isSwitched)
        .map<String>((e) => e.label));
    positions = setOfPositions.map((e) => e).toList(growable: false);
    nodesWithoutParent = await storageProvider.nodeBox.findNodesWithoutParent();
  }

  Future<void> removeNode(Node node) async {
    return await storageProvider.nodeBox.delete(node.id);
  }

  Future<int> createPosture(Node parent, String posture) async {
    // insert the posture into the db
    int id = await storageProvider.nodeBox.createPosture(parent, posture);
    await regenerateLists();
    return id;
  }

  Future<void> updateNodeLabel(Node node, String label) async {
    node.label = label;
    await storageProvider.nodeBox.updateNode(node);
    await regenerateLists();
  }

  Future<void> updateNodeIsExpanded(Node tree, bool isExpanded) async {
    tree.isExpanded = isExpanded;
    await storageProvider.nodeBox.updateNode(tree);
    await regenerateLists();
  }

  Future<void> deletePosture(Node child) async {
    await storageProvider.nodeBox.deletePosture(child);
    await regenerateLists();
  }

  Future<void> deleteCategory(Node category) async {
    await storageProvider.nodeBox.deleteCategory(category);
    await regenerateLists();
  }

  Future<void> createCategory(Node? parent, String category) async {
    await storageProvider.nodeBox.createCategory(parent, category);
    await regenerateLists();
  }

  Future<void> onSwitch(bool switched, Node tree) async {
    await storageProvider.nodeBox
        .enableOrDisable(storageProvider.nodeBox.toNodeEntity(tree)!, switched);
    await regenerateLists();
  }
}
