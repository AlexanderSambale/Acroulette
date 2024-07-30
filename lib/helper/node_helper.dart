import 'package:acroulette/models/entities/acro_node.dart';
import 'package:acroulette/models/dao/acro_node_dao.dart';
import 'package:acroulette/models/dao/node_node_dao.dart';
import 'package:acroulette/models/entities/node_entity.dart';
import 'package:acroulette/models/dao/node_acro_node_dao.dart';
import 'package:acroulette/models/dao/node_dao.dart';
import 'package:acroulette/models/relations/node_acro_node.dart';
import 'package:acroulette/models/relations/node_node.dart';

class NodeHelper {
  final NodeDao nodeDao;
  final AcroNodeDao acroNodeDao;
  final NodeAcroNodeDao nodeAcroNodeDao;
  final NodeNodeDao nodeNodeDao;

  NodeHelper(
      this.nodeDao, this.acroNodeDao, this.nodeAcroNodeDao, this.nodeNodeDao);

//  String? get label => acroNode.value?.label;
  Future<NodeEntity> createCategory(
    List<NodeEntity> children,
    AcroNode acroNode, {
    isLeaf = false,
    isExpanded = true,
    NodeEntity? parent,
  }) async {
    // create basic Node
    NodeEntity node = NodeEntity(isExpanded: isExpanded, isLeaf: isLeaf);
    // insert into DataBase and update id to node
    node.id = await nodeDao.put(node);

    // add children relationships
    for (var child in children) {
      nodeNodeDao.insertObject(NodeNode(node.id, child.id));
    }
    // add acroNode relationship
    await nodeAcroNodeDao.insertObject(NodeAcroNode(node.id, acroNode.id));
    if (parent != null) {
      nodeNodeDao.insertObject(NodeNode(parent.id, node.id));
    }
    return node;
  }

  Future<NodeEntity> createLeaf(
    AcroNode acroNode, {
    isLeaf = true,
    isExpanded = true,
    NodeEntity? parent,
  }) async {
    return createCategory(
      [],
      acroNode,
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
