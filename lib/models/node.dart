import 'dart:convert';

import 'package:acroulette/models/acro_node.dart';
import 'package:isar/isar.dart';

part 'node.g.dart';

const String isLeafKey = "isLeaf";
const String isExpandedKey = "isExpanded";
const String childrenKey = "children";
const String valueKey = "value";

@collection
class Node {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  bool isLeaf;

  @Index()
  IsarLink<Node> parent = IsarLink<Node>();
  IsarLinks<Node> children = IsarLinks<Node>();
  IsarLink<AcroNode> acroNode = IsarLink<AcroNode>();
  bool isExpanded;
  String? get label => acroNode.value?.label;

  Node({
    this.isLeaf = false,
    this.isExpanded = true,
  });

  Node.createCategory(
    List<Node> children,
    AcroNode acroNode, {
    this.isLeaf = false,
    this.isExpanded = true,
    Node? parent,
  }) {
    for (var child in children) {
      child.parent.value = this;
    }
    this.children.addAll(children);
    this.acroNode.value = acroNode;
    this.parent.value = parent;
    this.acroNode.saveSync();
    this.parent.saveSync();
    this.children.saveSync();
  }

  Node.createLeaf(
    AcroNode acroNode, {
    this.isLeaf = true,
    this.isExpanded = true,
    Node? parent,
  }) {
    this.acroNode.value = acroNode;
    this.parent.value = parent;
    this.acroNode.saveSync();
    this.parent.saveSync();
  }

  addNode(Node node) {
    if (isLeaf) Exception('This is a leaf! Nodes cannot be added.');
    children.add(node);
  }

  addAll(List<Node> nodes) {
    if (isLeaf) Exception('This is a leaf! Nodes cannot be added.');
    children.addAll(nodes);
  }

  removeNode(Node node) {
    if (isLeaf) Exception('This is a leaf! Nodes cannot be removed.');
    children.remove(node);
  }

  @override
  String toString() {
    String result = '''{''';
    if (children.isNotEmpty) {
      List<String> childrenAsJson = [];
      for (var child in children) {
        childrenAsJson.add(child.toString());
      }
      result = '''$result"$childrenKey": $childrenAsJson,''';
    }
    result = '''$result
  "$isLeafKey": $isLeaf,
  "$isExpandedKey": $isExpanded,
  "$valueKey": ${acroNode.value}
}''';
    return result;
  }

  static List<Node> createFromString(String source) {
    var decoded = jsonDecode(source);
    if (decoded is List) {
      return createFromListOfMaps(decoded);
    }
    if (decoded is Map<String, dynamic>) {
      return [createFromMap(decoded)];
    }
    throw Exception("Cannot be decoded, not correct type!");
  }

  static List<Node> createFromListOfMaps(List decoded) {
    List<Node> nodes = [];
    for (var map in decoded) {
      if (map is! Map) {
        throw Exception("Cannot be decoded, not correct type!");
      } else {
        nodes.add(createFromMap(map));
      }
    }
    return nodes;
  }

  static Node createFromMap(Map decoded) {
    List<Node> children = [];
    if (decoded[childrenKey] != null) {
      for (var child in decoded[childrenKey]) {
        children.add(Node.createFromMap(child));
      }
    }
    AcroNode value = AcroNode.createFromMap(decoded[valueKey]);
    return Node.createCategory(children, value,
        isLeaf: decoded[isLeafKey], isExpanded: decoded[isExpandedKey]);
  }

  @override
  bool operator ==(Object other) {
    if (other is! Node) return false;
    if (other.isExpanded != isExpanded) return false;
    if (other.isLeaf != isLeaf) return false;
    if (other.acroNode.value != acroNode.value) return false;
    if (other.children != other.children) return false;
    return true;
  }

  @override
  int get hashCode => Object.hash(isLeaf.hashCode, isExpanded.hashCode,
      children.hashCode, acroNode.hashCode);
}
