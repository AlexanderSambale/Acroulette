import 'dart:convert';

import 'package:acroulette/models/acro_node.dart';
import 'package:isar/isar.dart';

const String isLeafKey = "isLeaf";
const String isExpandedKey = "isExpanded";
const String childrenKey = "children";
const String valueKey = "value";

@collection
class Node {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  bool isLeaf;

  final parent = ToOne<Node>();
  ToMany<Node> children = ToMany<Node>();
  ToOne<AcroNode> value = ToOne<AcroNode>();
  bool isExpanded;
  String? get label => value.target?.label;

  Node(this.children, this.value,
      {this.isLeaf = false, this.isExpanded = true});

  Node.createCategory(List<Node> children, AcroNode acroNode,
      {this.isLeaf = false, this.isExpanded = true, Node? parent}) {
    for (var child in children) {
      child.parent.target = this;
    }
    this.children.addAll(children);
    this.parent.target = parent;
    value.target = acroNode;
  }

  Node.createLeaf(AcroNode acroNode,
      {this.isLeaf = true, this.isExpanded = true, Node? parent}) {
    this.parent.target = parent;
    value.target = acroNode;
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
  "$valueKey": ${value.target!}
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
    if (other.value.target != value.target) return false;
    if (other.children != other.children) return false;
    return true;
  }

  @override
  int get hashCode => Object.hash(
      isLeaf.hashCode, isExpanded.hashCode, children.hashCode, value.hashCode);
}
