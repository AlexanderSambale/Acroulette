import 'package:acroulette/models/entities/base_entity.dart';
import 'package:floor/floor.dart';

@entity
class Position extends BaseEntity {
  final String name;

  Position(this.name);
}
