import 'package:floor/floor.dart';

abstract class BaseEntity {
  @PrimaryKey(autoGenerate: true)
  int? autoId;

  int get id => autoId!;
  set id(int newId) => autoId = newId;
}
