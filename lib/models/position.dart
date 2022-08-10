import 'package:objectbox/objectbox.dart';

@Entity()
class Position {
  int id = 0;

  final String name;

  Position(this.name);
}
