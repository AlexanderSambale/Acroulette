// database.dart

// required package imports
import 'dart:async';
import 'dart:typed_data';
import 'package:acroulette/models/dao/flow_node_dao.dart';
import 'package:acroulette/models/dao/node_dao.dart';
import 'package:acroulette/models/dao/node_node_dao.dart';
import 'package:acroulette/models/dao/node_without_parent_dao.dart';
import 'package:acroulette/models/dao/settings_pair_dao.dart';
import 'package:acroulette/models/entities/flow_node_entity.dart';
import 'package:acroulette/models/entities/node_entity.dart';
import 'package:acroulette/models/entities/settings_pair.dart';
import 'package:acroulette/models/relations/node_node.dart';
import 'package:acroulette/models/relations/node_without_parent.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:acroulette/models/pair.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [
  NodeEntity,
  SettingsPair,
  NodeNode,
  NodeWithoutParent,
  FlowNodeEntity,
])
abstract class AppDatabase extends FloorDatabase {
  SettingsPairDao get settingsPairDao;
  NodeNodeDao get nodeNodeDao;
  NodeDao get nodeDao;
  FlowNodeDao get flowNodeDao;
  NodeWithoutParentDao get nodeWithoutParentDao;

  Future<List<NodeNode>> getAllNodeNodesRecursively(int id) async {
    String queryString = '''WITH RECURSIVE cte AS (
    -- Base case: select rows where first column equals the initial value
    SELECT parentId, childId 
    FROM NodeNode nn1
    WHERE nn1.parentId = ?
    
    UNION ALL
    
    -- Recursive case: select rows where first column matches previous iteration's second column
    SELECT nn2.parentId, nn2.childId 
    FROM NodeNode nn2
    INNER JOIN cte ON cte.childId = nn2.parentId
)
SELECT * FROM cte
''';
    final result = await database.rawQuery(queryString, [id]);
    return result
        .map((element) =>
            NodeNode(element["parentId"] as int, element["childId"] as int))
        .toList(growable: false);
  }

  Future<void> enableOrDisable(
    NodeEntity tree,
    bool isSwitched,
  ) async {
    String queryString = '''
    UPDATE NodeEntity
    SET isSwitched = ?, isEnabled
    WHERE autoId = ?
''';
    await database.rawQuery(queryString, [
      isSwitched.toInt(),
      tree.id,
    ]);
  }
}

extension BooleanExtension on bool {
  int toInt() => this ? 1 : 0;
}
