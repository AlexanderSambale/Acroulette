import 'package:acroulette/models/entities/base_entity.dart';
import 'package:floor/floor.dart';

@entity
class NodeEntity extends BaseEntity {
  final bool isLeaf;
  final bool isExpanded;
  final bool isSwitched;
  final bool isEnabled;
  final String label;

  NodeEntity(
    super.autoId,
    this.isSwitched,
    this.label, {
    this.isEnabled = true,
    this.isLeaf = false,
    this.isExpanded = true,
  });

  factory NodeEntity.optional({
    int? autoId,
    bool? isLeaf,
    bool? isExpanded,
    bool? isSwitched,
    bool? isEnabled,
    String? label,
  }) =>
      NodeEntity(
        autoId,
        isSwitched ?? true,
        label ?? '',
        isLeaf: isLeaf ?? false,
        isEnabled: isEnabled ?? true,
        isExpanded: isExpanded ?? true,
      );
}
