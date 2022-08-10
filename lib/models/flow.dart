import 'package:objectbox/objectbox.dart';

@Entity()
class Flow {
  int id = 0;

  final String name;
  final List<String> positions;

  Flow(this.name, this.positions);
}
