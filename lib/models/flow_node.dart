import 'dart:convert';

import 'package:objectbox/objectbox.dart';

const String nameKey = "name";
const String positionsKey = "positions";

@Entity()
class FlowNode {
  int id = 0;

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
    List<String> flowPositions = [];
    for (var position in decoded[positionsKey]) {
      flowPositions.add(position);
    }
    return FlowNode(decoded[nameKey], flowPositions);
  }
}
