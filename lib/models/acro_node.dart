import 'package:objectbox/objectbox.dart';

@Entity()
class AcroNode {
  AcroNode(this.isSwitched, this.label,
      {this.isEnabled = true, this.predefined = false});

  int id = 0;
  bool isSwitched;
  bool isEnabled;
  String label;
  // initial Node, set by developer to true, else it should be false
  bool predefined;
}
