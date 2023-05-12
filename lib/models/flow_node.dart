import 'dart:convert';

import 'package:objectbox/objectbox.dart';

const String cName = "name";
const String cPositions = "positions";

@Entity()
class FlowNode {
  int id = 0;

  String name;
  final List<String> positions;
  bool isExpanded;

  FlowNode(this.name, this.positions, {this.isExpanded = true});

  @override
  String toString() {
    return '''{"$cName":"$name", "$cPositions":${jsonEncode(positions)}}''';
  }

  static FlowNode createFromString(String source) {
    Map decoded = jsonDecode(source);
    List<String> flowPositions = [];
    for (var position in decoded[cPositions]) {
      flowPositions.add(position);
    }
    return FlowNode(decoded[cName], flowPositions);
  }
}
