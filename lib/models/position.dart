import 'package:isar/isar.dart';

@collection
class Position {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  final String name;

  Position(this.name);
}
