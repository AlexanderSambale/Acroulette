import 'dart:convert';

const String isLeafKey = "isLeaf";
const String isExpandedKey = "isExpanded";
const String childrenKey = "children";
const String isSwitchedKey = "isSwitched";
const String labelKey = "label";
const String isEnabledKey = "isEnabled";

class Node {
  int? id;
  bool isLeaf;
  bool isExpanded;
  bool isSwitched;
  bool isEnabled;
  String label;

  final Node? parent;
  List<Node> children;

  Node({
    this.id,
    this.parent,
    required this.children,
    required this.isSwitched,
    required this.label,
    required this.isEnabled,
    required this.isLeaf,
    required this.isExpanded,
  });

  // ToDo check if we need a deepcopy for children
  factory Node.optional({
    int? id,
    Node? parent,
    List<Node>? children,
    bool? isLeaf,
    bool? isExpanded,
    bool? isSwitched,
    bool? isEnabled,
    String? label,
  }) =>
      Node(
        id: id,
        label: label ?? '',
        isSwitched: isSwitched ?? true,
        isEnabled: isEnabled ?? true,
        isExpanded: isExpanded ?? true,
        isLeaf: isLeaf ?? false,
        children: children ?? [],
        parent: parent,
      );

  static Node createLeaf({
    int? id,
    Node? parent,
    bool? isExpanded,
    bool? isSwitched,
    bool? isEnabled,
    String? label,
  }) {
    Node newNode = Node.optional(
      id: id,
      label: label ?? '',
      isSwitched: isSwitched ?? true,
      isEnabled: isEnabled ?? true,
      isExpanded: isExpanded ?? true,
      isLeaf: true,
      parent: parent,
      children: [],
    );
    // ToDo check if we need a deepcopy for children
    return newNode;
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
  "$isSwitchedKey": $isSwitched,
  "$labelKey": "$label",
  "$isEnabledKey": $isEnabled
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
    return Node(
      isEnabled: decoded[isEnabledKey],
      isLeaf: decoded[isLeafKey],
      isExpanded: decoded[isExpandedKey],
      children: children,
      isSwitched: decoded[isSwitchedKey],
      label: decoded[labelKey],
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! Node) return false;
    if (other.isExpanded != isExpanded) return false;
    if (other.isLeaf != isLeaf) return false;
    if (other.isEnabled != isEnabled) return false;
    if (other.isSwitched != isSwitched) return false;
    if (other.label != label) return false;
    if (other.children != other.children) return false;
    return true;
  }

  @override
  int get hashCode => Object.hash(
        isLeaf.hashCode,
        isExpanded.hashCode,
        children.hashCode,
        isSwitched.hashCode,
        isEnabled.hashCode,
        label.hashCode,
      );
}
