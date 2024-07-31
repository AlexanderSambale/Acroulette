import 'dart:typed_data';

import 'package:acroulette/models/entities/base_entity.dart';
import 'package:floor/floor.dart';

@entity
class FlowNodeEntity extends BaseEntity {
  String name;
  final Uint8List positions;
  bool isExpanded;

  FlowNodeEntity(
    super.autoId,
    this.name,
    this.positions, {
    this.isExpanded = true,
  });

  factory FlowNodeEntity.optional({
    int? autoId,
    String? name,
    Uint8List? positions,
    bool? isExpanded,
  }) =>
      FlowNodeEntity(
        autoId,
        name ?? '',
        positions ?? Uint8List(0),
        isExpanded: isExpanded ?? true,
      );
}
