import 'dart:convert';
import 'package:isar/isar.dart';

const String nameKey = "name";
const String positionsKey = "positions";

@collection
class FlowNode {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  String name;
  final List<String> positions;
  bool isExpanded;

  FlowNode(this.name, this.positions, {this.isExpanded = true});

  @override
  String toString() {
    return '''{"$nameKey":"$name", "$positionsKey":${jsonEncode(positions)}}''';
  }

  static FlowNode createFromString(String source) {
    Map decoded = jsonDecode(source);
    return createFromMap(decoded);
  }

  static FlowNode createFromMap(Map decoded) {
    List<String> flowPositions = [];
    for (var position in decoded[positionsKey]) {
      flowPositions.add(position);
    }
    return FlowNode(decoded[nameKey], flowPositions);
  }
}
