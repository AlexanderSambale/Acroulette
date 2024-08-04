import 'package:acroulette/models/dao/node_node_dao.dart';
import 'package:acroulette/models/dao/node_without_parent_dao.dart';
import 'package:acroulette/models/entities/node_entity.dart';
import 'package:acroulette/models/dao/node_dao.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/relations/node_node.dart';
import 'package:acroulette/models/relations/node_without_parent.dart';

class NodeHelper {
  final NodeDao nodeDao;
  final NodeNodeDao nodeNodeDao;
  final NodeWithoutParentDao nodeWithoutParentDao;

  NodeHelper(this.nodeDao, this.nodeNodeDao, this.nodeWithoutParentDao);

  Future<int?> count() {
    return nodeDao.count();
  }

  Future<List<Node>> findAll() async {
    List<NodeEntity> nodeEntities = await nodeDao.findAll();
    List<Node> nodes = [];
    for (var nodeEntity in nodeEntities) {
      nodes.add((await toNode(nodeEntity))!);
    }
    return nodes;
  }

  Future<int> insertTree(Node node) async {
    if (node.id == null) {
      // insert node into database
      int id = await nodeDao.put(toNodeEntity(node)!);
      if (node.parent != null && node.parent!.id != null) {
        // parent is in database
        // create relationship
        insertNodeNode(node.parent!.id!, id);
      } else {
        // has no parent in database
        // create relationship no parent
        NodeWithoutParent nodeWithoutParent = NodeWithoutParent(id);
        await nodeWithoutParentDao.insertObject(nodeWithoutParent);
      }
      for (var child in node.children) {
        int childId = await insertTree(child);
        // create relationship
        insertNodeNode(id, childId);
      }
      return id;
    }
    throw Exception('Tree is already in database');
  }

  Future<List<int>> insertTrees(List<Node> nodes) async {
    List<int> ids = [];
    for (var node in nodes) {
      ids.add(await insertTree(node));
    }
    return ids;
  }

  Future<void> delete(int? id) async {
    if (id == null) {
      throw Exception("Id is null, cannot delete Node!");
    }
    // delete relationships
    // parent
    // children
    await nodeDao.deleteById(id);
  }

  Future<void> deleteAll(List<int?> ids) async {
    for (var id in ids) {
      await delete(id);
    }
  }

  Future<List<Node>> findNodesWithoutParent() async {
    List<NodeWithoutParent> nodesWithoutParent =
        await nodeWithoutParentDao.findAll();
    List<int> nodeNodesIds =
        nodesWithoutParent.map((node) => node.nodeId).toList();
    List<NodeEntity?> nodeEntities = await nodeDao.findAllById(nodeNodesIds);
    List<Node> nodes = [];
    for (var nodeEntity in nodeEntities) {
      if (nodeEntity == null) {
        throw Exception("Node not found, but relation exists!");
      }
      nodes.add((await toNode(nodeEntity))!);
    }
    return nodes;
  }

  NodeEntity? toNodeEntity(Node? node) {
    if (node == null) {
      return null;
    }
    return NodeEntity.optional(
      autoId: node.id,
      isSwitched: node.isSwitched,
      label: node.label,
      isEnabled: node.isEnabled,
      isExpanded: node.isExpanded,
      isLeaf: node.isLeaf,
    );
  }

  Future<Node?> toNode(NodeEntity? nodeEntity) async {
    if (nodeEntity == null) {
      return null;
    }
    NodeNode? parentNodeNode =
        await nodeNodeDao.findParentByChildId(nodeEntity.id);
    Node? parent = null;
    if (parentNodeNode != null) {
      NodeEntity? parentEntity =
          await nodeDao.findEntityById(parentNodeNode.parentId!);
      parent = toNode(parentEntity);
    }

    List<NodeNode?> childNodeNodes =
        await nodeNodeDao.findChildrenByParentId(nodeEntity.id);

    Node node = Node(
      null,
      isLeaf: nodeEntity.isLeaf,
      isExpanded: nodeEntity.isExpanded,
    );
    node.id = nodeEntity.id;
    return node;
  }

  Future<NodeEntity> createCategoryNodeEntity(
    List<NodeEntity> children, {
    isLeaf = false,
    isExpanded = true,
    NodeEntity? parent,
  }) async {
    // create basic Node
    NodeEntity node = NodeEntity(null, isExpanded: isExpanded, isLeaf: isLeaf);
    // insert into DataBase and update id to node
    node.id = await nodeDao.put(node);

    // add children relationships
    for (var child in children) {
      nodeNodeDao.insertObject(NodeNode(node.id, child.id));
    }
    if (parent != null) {
      nodeNodeDao.insertObject(NodeNode(parent.id, node.id));
    }
    return node;
  }

  Future<NodeEntity> createLeaf({
    isLeaf = true,
    isExpanded = true,
    NodeEntity? parent,
  }) async {
    return createCategoryNodeEntity(
      [],
      isExpanded: isExpanded,
      isLeaf: isLeaf,
      parent: parent,
    );
  }

  List<Node> nodes = [];

  addNode(NodeEntity node, NodeEntity child) {
    if (node.isLeaf) Exception('This is a leaf! Nodes cannot be added.');
    nodeNodeDao.insertObject(NodeNode(node.id, child.id));
  }

  addAll(NodeEntity node, List<NodeEntity> children) {
    if (node.isLeaf) Exception('This is a leaf! Nodes cannot be added.');
    for (var child in children) {
      nodeNodeDao.insertObject(NodeNode(node.id, child.id));
    }
  }

  removeNode(NodeEntity node, NodeEntity child) {
    if (node.isLeaf) Exception('This is a leaf! Nodes cannot be removed.');
    nodeNodeDao.removeObject(NodeNode(node.id, child.id));
  }

  Future<void> insertNodeNode(int? parentId, int? childId) async {
    if (parentId == null) {
      throw Exception(
          "Parent child relationship with parentId null cannot be inserted!");
    }
    if (childId == null) {
      throw Exception(
          "Parent child relationship with childId null cannot be inserted!");
    }
    NodeNode nodeNode = NodeNode(parentId, childId);
    await nodeNodeDao.insertObject(nodeNode);
  }

  Future<int> createPosture(Node parent, String posture) async {
    NodeEntity newPosture = NodeEntity.optional(label: posture);
    int id = await nodeDao.put(newPosture);
    // create the parent child relationship
    await insertNodeNode(parent.id, id);
    return id;
  }

  Future<void> updateNode(Node node) async {
    await nodeDao.updateObject(toNodeEntity(node)!);
  }

  Future<List<int>> getChildrenIdsRecursively(int id) async {
    List<NodeNode> nodeNodes = await nodeNodeDao.getAllNodeNodesRecursively(id);
    Set<int> ids = {};
    for (var nodeNode in nodeNodes) {
      ids.add(nodeNode.childId);
      ids.add(nodeNode.parentId);
    }
    return ids.toList();
  }

  Future<void> deletePosture(Node node) async {
    if (node.id == null) {
      throw Exception("node is not in database and cannot be deleted");
    }
    await nodeNodeDao.deleteByChildId(node.id!);
    await nodeDao.deleteById(node.id!);
  }

  Future<void> deleteCategory(Node node) async {
    if (node.id == null) {
      throw Exception("node is not in database and cannot be deleted");
    }
    List<int> ids = await getChildrenIdsRecursively(node.id!);
    // Delete relationships
    await nodeNodeDao.deleteByParentIds(ids);
    await nodeWithoutParentDao.deleteById(node.id!);
    // Delete nodes
    await nodeDao.deleteByIds(ids);
  }

  Future<int> createCategory(Node? parent, String category) async {
    NodeEntity newCategory = NodeEntity.optional(label: category);
    int id = await nodeDao.put(newCategory);
    if (parent != null) {
      // create the parent child relationship
      await insertNodeNode(parent.id, id);
    }
    return id;
  }

  /// Depending on [isSwitched] we enable or disable recursive [Nodes] from
  /// this [tree].
  ///
  /// Here is a table, what to do in which case.
  ///
  /// state | toEnable | toDisable
  /// ----|----|----
  /// enabled, switch on| /| disabled on, disable others
  /// disabled, switch on| enable on, enable others| /
  /// enabled, switch off| /| disable off, nothing else
  /// disabled, switch off| enable off, nothing else|/
  Future<void> enableOrDisable(
    NodeEntity tree,
    bool isSwitched,
  ) async {
    // update tree node
    NodeEntity newTree = tree.copyWith(isSwitched: isSwitched);
    await nodeDao.updateObject(newTree);
    // get children through parent child relationship
    List<NodeNode> nodeNodes =
        await nodeNodeDao.findChildrenByParentId(newTree.id);
    List<NodeEntity?> children = await nodeDao
        .findAllById(nodeNodes.map((nodeNode) => nodeNode.childId).toList());
    for (var node in children) {
      assert(node != null); // nodes to childIds should be available
      if (node!.isSwitched) {
        // if child switch is on, change [isEnabled] to [isSwitched]
        // recursive for all childs of the child
        NodeEntity newNode = node.copyWith(isEnabled: isSwitched);
        enableOrDisable(newNode, isSwitched);
      }
    }
  }
}
