import 'package:objectbox/objectbox.dart';

@Entity()
class AcroNode {
  AcroNode(this.isSwitched, this.label, {this.isEnabled = true});

  int id = 0;
  bool isSwitched;
  bool isEnabled;
  String label;
}
