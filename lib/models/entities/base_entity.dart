import 'package:floor/floor.dart';

abstract class BaseEntity {
  @PrimaryKey(autoGenerate: true)
  int? autoId;

  int get id {
    assert(autoId != null);
    return autoId!;
  }

  set id(int newId) => autoId = newId;

  BaseEntity(this.autoId);
}
