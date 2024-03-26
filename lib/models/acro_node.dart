import 'dart:convert';
import 'package:isar/isar.dart';

const String isSwitchedKey = "isSwitched";
const String labelKey = "label";
const String isEnabledKey = "isEnabled";

@collection
class AcroNode {
  AcroNode(this.isSwitched, this.label, {this.isEnabled = true});

  int id = 0;
  bool isSwitched;
  bool isEnabled;
  String label;

  @override
  String toString() {
    return '''{"$isSwitchedKey": $isSwitched, "$labelKey": "$label", "$isEnabledKey": $isEnabled}''';
  }

  static AcroNode createFromString(String source) {
    Map decoded = jsonDecode(source);
    return createFromMap(decoded);
  }

  static AcroNode createFromMap(Map decoded) {
    return AcroNode(decoded[isSwitchedKey], decoded[labelKey],
        isEnabled: decoded[isEnabledKey]);
  }

  @override
  bool operator ==(Object other) {
    if (other is! AcroNode) return false;
    if (other.isEnabled != isEnabled) return false;
    if (other.isSwitched != isSwitched) return false;
    if (other.label != label) return false;
    return true;
  }

  @override
  int get hashCode =>
      Object.hash(isSwitched.hashCode, isEnabled.hashCode, label.hashCode);
}
