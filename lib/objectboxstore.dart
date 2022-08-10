import 'package:acroulette/models/commands.dart';

import 'database/objectbox.g.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  late final Box<Commands> commandsBox;

  ObjectBox._create(this.store) {
    commandsBox = Box<Commands>(store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
    return ObjectBox._create(store);
  }
}
