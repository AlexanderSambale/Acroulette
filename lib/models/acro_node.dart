import 'package:objectbox/objectbox.dart';

@Entity()
class AcroNode {
  AcroNode(this.isSwitched, this.label);

  int id = 0;
  bool isSwitched;
  String label;
}
