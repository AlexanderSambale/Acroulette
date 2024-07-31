import 'dart:convert';

import 'package:acroulette/models/entities/base_entity.dart';
import 'package:floor/floor.dart';

const String isSwitchedKey = "isSwitched";
const String labelKey = "label";
const String isEnabledKey = "isEnabled";

@entity
class AcroNode extends BaseEntity {
  AcroNode(super.autoId, this.isSwitched, this.label, {this.isEnabled = true});
  bool isSwitched;
  bool isEnabled;
  String label;

  factory AcroNode.optional({
    int? autoId,
    bool? isSwitched,
    bool? isEnabled,
    String? label,
  }) =>
      AcroNode(
        autoId,
        isSwitched ?? false,
        label ?? '',
        isEnabled: isEnabled ?? true,
      );

  @override
  String toString() {
    return '''{"$isSwitchedKey": $isSwitched, "$labelKey": "$label", "$isEnabledKey": $isEnabled}''';
  }

  static AcroNode createFromString(String source) {
    Map decoded = jsonDecode(source);
    return createFromMap(decoded);
  }

  static AcroNode createFromMap(Map decoded) {
    return AcroNode(null, decoded[isSwitchedKey], decoded[labelKey],
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
