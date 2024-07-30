import 'dart:typed_data';

import 'package:acroulette/models/entities/base_entity.dart';
import 'package:floor/floor.dart';

@entity
class FlowNodeEntity extends BaseEntity {
  String name;
  final Uint8List positions;
  bool isExpanded;

  FlowNodeEntity(
    this.name,
    this.positions, {
    this.isExpanded = true,
  });
}
