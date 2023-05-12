import 'dart:convert';

import 'package:objectbox/objectbox.dart';

const String cIsSwitched = "isSwitched";
const String cLabel = "label";

@Entity()
class AcroNode {
  AcroNode(this.isSwitched, this.label,
      {this.isEnabled = true, this.predefined = false});

  int id = 0;
  bool isSwitched;
  bool isEnabled;
  String label;
  // initial Node, set by developer to true, else it should be false
  bool predefined;

  @override
  String toString() {
    return '''{"$cIsSwitched": $isSwitched, "$cLabel": "$label"}''';
  }

  static AcroNode createFromString(String source) {
    Map decoded = jsonDecode(source);
    return AcroNode(decoded[cIsSwitched], decoded[cLabel]);
  }
}
