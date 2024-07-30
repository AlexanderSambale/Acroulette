import 'dart:convert';

import 'package:acroulette/models/entities/base_entity.dart';

const String nameKey = "name";
const String positionsKey = "positions";

class FlowNode extends BaseEntity {
  String name;
  final List<String> positions;
  bool isExpanded;

  FlowNode(
    this.name,
    this.positions, {
    this.isExpanded = true,
  });

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
