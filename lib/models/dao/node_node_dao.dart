import 'package:acroulette/models/relations/node_node.dart';
import 'package:floor/floor.dart';

@dao
abstract class NodeNodeDao {
  @insert
  Future<void> insertObject(NodeNode nodeNode);

  @delete
  Future<void> removeObject(NodeNode nodeNode);

  @Query('SELECT * FROM NodeNode WHERE childId = :id')
  Future<NodeNode?> findParentByChildId(int id);

  @Query('DELETE * FROM NodeNode WHERE childId = :id')
  Future<NodeNode?> deleteByChildId(int id);

  @Query('DELETE * FROM NodeNode WHERE parentId = :id')
  Future<NodeNode?> deleteByParentId(int id);

  @Query('SELECT * FROM NodeNode WHERE parentId = :id')
  Future<List<NodeNode?>> findChildrenByParentId(int id);

  @Query('''WITH RECURSIVE cte AS (
    -- Base case: select rows where first column equals the initial value
    SELECT parentId, childId 
    FROM NodeNode 
    WHERE parentId = :id
    
    UNION ALL
    
    -- Recursive case: select rows where first column matches previous iteration's second column
    SELECT t.parentId, t.childId
    FROM NodeNode nn
    INNER JOIN cte ON nn.parentId = cte.childId
)
SELECT * FROM cte
''')
  Future<List<NodeNode>> getAllNodeNodesRecursively(int id);

  Future<void> deleteByParentIds(List<int> ids) async {
    for (var id in ids) {
      await deleteByParentId(id);
    }
  }
}
