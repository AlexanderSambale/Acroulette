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

  Future<int> put(Node node) async {
    int id = await nodeDao.put(toNodeEntity(node));
    await nodeNodeDao.insertObject(nodeNode);
    for (var child in node.children) {
      await nodeNodeDao.insertObject(child);
    }
    return id;
  }

  Future<List<int>> putAll(List<Node> nodes) async {
    List<int> ids = [];
    for (var node in nodes) {
      ids.add(await put(node));
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
    List<NodeNode> nodeNodes = await nodeNodeDao.findNodesWithoutParent();
    List<int> nodeNodesIds =
        nodeNodes.map((nodeNode) => nodeNode.childId).toList();
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

//  String? get label => acroNode.value?.label;
  Future<NodeEntity> createCategory(
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
    return createCategory(
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
}
