// database.dart

// required package imports
import 'dart:async';
import 'dart:typed_data';
import 'package:acroulette/models/dao/flow_node_dao.dart';
import 'package:acroulette/models/dao/node_dao.dart';
import 'package:acroulette/models/dao/node_node_dao.dart';
import 'package:acroulette/models/dao/position_dao.dart';
import 'package:acroulette/models/dao/settings_pair_dao.dart';
import 'package:acroulette/models/entities/flow_node_entity.dart';
import 'package:acroulette/models/entities/node_entity.dart';
import 'package:acroulette/models/entities/position.dart';
import 'package:acroulette/models/entities/settings_pair.dart';
import 'package:acroulette/models/relations/node_node.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [
  NodeEntity,
  SettingsPair,
  Position,
  NodeNode,
  FlowNodeEntity,
])
abstract class AppDatabase extends FloorDatabase {
  SettingsPairDao get settingsPairDao;
  PositionDao get positionDao;
  NodeNodeDao get nodeNodeDao;
  NodeDao get nodeDao;
  FlowNodeDao get flowNodeDao;
}
