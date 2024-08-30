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

  @transaction
  Future<void> enableOrDisable(
    NodeEntity tree,
    bool isSwitched,
  ) async {
    int isSwitchedInt = isSwitched.toInt();
    // update the root
    String queryString = '''
        UPDATE NodeEntity
        SET isSwitched = ?
        WHERE autoId = ?
  ''';
    await database.rawQuery(queryString, [
      isSwitchedInt,
      tree.id,
    ]);
    // update the children
    queryString = '''
        WITH RECURSIVE children AS (
          -- Base case: root node
          SELECT nn.childId, n.isSwitched
          FROM NodeNode nn
          INNER JOIN NodeEntity n ON nn.parentId = ? AND n.autoId = nn.childId

          UNION ALL
          
          -- Recursive case: find all children with nested isSwitched true
          SELECT nn2.childId, n.isSwitched
          FROM NodeNode nn2
            INNER JOIN NodeEntity n ON n.autoId = nn2.parentId
            INNER JOIN children ON children.childId = n.autoId AND children.isSwitched = 1
        )
        -- enableOrDisable all
        UPDATE NodeEntity
        SET isEnabled = ?
        WHERE autoId IN (SELECT childId FROM children);
''';
    await database.rawQuery(queryString, [
      tree.id,
      isSwitchedInt,
    ]);
  }
}

extension BooleanExtension on bool {
  int toInt() => this ? 1 : 0;
}
