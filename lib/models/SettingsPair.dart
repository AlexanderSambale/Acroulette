import 'package:objectbox/objectbox.dart';

@Entity()
class SettingsPair {
  int id = 0;

  late String key;
  late String value;

  SettingsPair(this.key, this.value);
}
