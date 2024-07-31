import 'package:acroulette/models/entities/base_entity.dart';
import 'package:floor/floor.dart';

@entity
class NodeEntity extends BaseEntity {
  final bool isLeaf;

  final bool isExpanded;

  NodeEntity(
    super.autoId, {
    this.isLeaf = false,
    this.isExpanded = true,
  });

  factory NodeEntity.optional({
    int? autoId,
    bool? isLeaf,
    bool? isExpanded,
  }) =>
      NodeEntity(
        autoId,
        isLeaf: isLeaf ?? false,
        isExpanded: isExpanded ?? true,
      );
}
