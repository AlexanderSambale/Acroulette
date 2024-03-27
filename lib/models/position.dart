import 'package:isar/isar.dart';

part 'position.g.dart';

@collection
class Position {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  @Index()
  final String name;

  Position(this.name);
}
