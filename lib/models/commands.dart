import 'package:objectbox/objectbox.dart';

@Entity()
class Commands {
  int id = 0;

  late String nextCommand;
  late String newCommand;
  late String previousCommand;
  late String currentCommand;

  Commands(
      {String? nextCommand,
      String? newCommand,
      String? previousCommand,
      String? currentCommand}) {
    this.nextCommand = nextCommand ?? 'next position';
    this.newCommand = newCommand ?? 'new position';
    this.previousCommand = previousCommand ?? 'previous position';
    this.currentCommand = currentCommand ?? 'current position';
  }
}
