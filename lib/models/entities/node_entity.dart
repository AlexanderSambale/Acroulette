import 'package:acroulette/models/entities/base_entity.dart';
import 'package:floor/floor.dart';

@entity
class NodeEntity extends BaseEntity {
  final bool isLeaf;

  final bool isExpanded;

  NodeEntity({
    this.isLeaf = false,
    this.isExpanded = true,
  });
}
