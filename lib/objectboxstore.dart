import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/models/SettingsPair.dart';
import 'package:acroulette/models/position.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  late final Box<SettingsPair> settingsBox;
  late final Box<Position> positionBox;

  ObjectBox._create(this.store) {
    settingsBox = Box<SettingsPair>(store);
    positionBox = Box<Position>(store);

    if (positionBox.isEmpty()) {
      List<Position> figures = [
        "bird",
        "star",
        "bat",
        "triangle",
        "backbird",
        "reversebird",
        "throne",
        "chair",
        "fallen leaf",
        "side star",
        "vishnus couch",
        "high flying whale"
      ].map<Position>((figure) => Position(figure)).toList();
      positionBox.putMany(figures);
    }
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
    return ObjectBox._create(store);
  }

  String getSettingsPairValueByKey(String key) {
    Query<SettingsPair> keyQuery =
        settingsBox.query(SettingsPair_.key.equals(key)).build();
    SettingsPair? keyQueryFirstValue = keyQuery.findFirst();
    if (keyQueryFirstValue == null) {
      return key;
    } else {
      return keyQueryFirstValue.value;
    }
  }

  void putSettingsPairValueByKey(String key, String value) {
    Query<SettingsPair> keyQuery =
        settingsBox.query(SettingsPair_.key.equals(key)).build();
    SettingsPair? keyQueryFirstValue = keyQuery.findFirst();
    if (keyQueryFirstValue == null) {
      settingsBox.put(SettingsPair(key, value));
    } else {
      keyQueryFirstValue.value = value;
      settingsBox.put(keyQueryFirstValue);
    }
  }

  String? getPosition(String positionName) {
    Query<Position> keyQuery =
        positionBox.query(Position_.name.equals(positionName)).build();
    Position? keyQueryFirstValue = keyQuery.findFirst();
    if (keyQueryFirstValue == null) {
      return null;
    } else {
      return keyQueryFirstValue.name;
    }
  }
}
