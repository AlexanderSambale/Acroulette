import 'package:acroulette/models/dao/node_node_dao.dart';
import 'package:acroulette/models/entities/node_entity.dart';
import 'package:acroulette/models/dao/node_dao.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/relations/node_node.dart';

class NodeHelper {
  final NodeDao nodeDao;
  final NodeNodeDao nodeNodeDao;

  NodeHelper(this.nodeDao, this.nodeNodeDao);

  Future<int?> count() {
    return nodeDao.count();
  }

  Future<List<Node?>> findAll() async {
    List<NodeEntity?> nodeEntities = await nodeDao.findAll();
    List<Node?> nodes = [];
    for (var nodeEntity in nodeEntities) {
      if (nodeEntity == null) {
        nodes.add(null);
        break;
      }
      nodes.add(await toNode(nodeEntity));
    }
    return nodes;
  }

  Future<Node?> toNode(NodeEntity? nodeEntity) async {
    if (nodeEntity == null) {
      return null;
    }
    NodeNode? parentNodeNode =
        await nodeNodeDao.findParentByChildId(nodeEntity.id);
    List<NodeNode?> childNodeNodes =
        await nodeNodeDao.findByChildrenByParentId(nodeEntity.id);
    NodeEntity? parentEntity =
        await nodeDao.findEntityById(parentNodeNode.parentId);

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
