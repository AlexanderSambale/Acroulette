import 'package:acroulette/constants/nodes.dart';
import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/position.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'position_administration_event.dart';
part 'position_administration_state.dart';

class PositionAdministrationBloc
    extends Bloc<PositionAdministrationEvent, BasePositionAdministrationState> {
  PositionAdministrationBloc(this.objectbox)
      : super(PositionAdministrationInitialState()) {
    Node tmpTree = findRoot();
    tree = tmpTree;
    state.tree = tmpTree;

    on<PositionsBDStartChangeEvent>((event, emit) {
      emit(PositionAdministrationState());
    });
    on<PositionsDBIsChangingEvent>((event, emit) {
      emit(PositionAdministrationState());
    });
    on<PositionsDBIsIdleEvent>((event, emit) {
      emit(PositionAdministrationInitialState.withTree(findRoot()));
    });
  }

  late ObjectBox objectbox;
  late Node tree;

  /// Depending on [isSwitched] we enable or disable recursive [acroNodes] from
  /// this [tree].
  ///
  /// Here is a table, what to do in which case.
  ///
  /// state | toEnable | toDisable
  /// ----|----|----
  /// enabled switch on| /| disabled on, disable others
  /// disable switch on| enable on, enable others| /
  /// enabled switch off| /| disable off, nothing else
  /// disable switch off| enable off, nothing else|/
  void enableOrDisableAndAddAcroNodes(
      List<AcroNode> acroNodes, Node tree, bool isSwitched) {
    for (var node in tree.children) {
      AcroNode acroNode = node.value.target!;
      if (acroNode.isSwitched) {
        enableOrDisableAndAddAcroNodes(acroNodes, node, isSwitched);
      }
      acroNode.isEnabled = isSwitched;
      acroNodes.add(acroNode);
    }
  }

  void onSwitch(bool switched, Node tree) {
    add(PositionsBDStartChangeEvent());
    AcroNode acroNode = tree.value.target!;
    acroNode.isSwitched = switched;
    List<AcroNode> acroNodes = [];
    enableOrDisableAndAddAcroNodes(acroNodes, tree, switched);
    if (tree.isLeaf) {
      regeneratePositionsList([acroNode]);
    } else {
      regeneratePositionsList(acroNodes);
    }
    acroNodes.add(acroNode);

    objectbox.putManyAcroNodes(acroNodes);
    objectbox.putNode(tree);
    add(PositionsDBIsIdleEvent());
  }

  void toggleExpand(Node tree) {
    add(PositionsBDStartChangeEvent());
    tree.isExpanded = !tree.isExpanded;
    objectbox.putNode(tree);
    add(PositionsDBIsIdleEvent());
  }

  Node findRoot() {
    QueryBuilder<Node> builder = objectbox.nodeBox.query();
    builder.link(
        Node_.value,
        AcroNode_.predefined.equals(true) &
            AcroNode_.label.equals(basicPostures));
    Query<Node> query = builder.build();
    Node? tmpTree = query.findUnique();
    query.close();
    // Error handling ToDo
    if (tmpTree == null) {
      throw Error();
    }
    return tmpTree;
  }

  void regeneratePositionsList(List<AcroNode> acroNodes) {
    List<Position> positions = objectbox.positionBox.getAll();
    Set<String> setOfPositions = {};
    setOfPositions.addAll(positions.map<String>((e) => e.name));
    objectbox.positionBox.removeAll();
    objectbox.positionBox.putMany(setOfPositions
        .difference(acroNodes
            .where((element) => !element.isSwitched || !element.isEnabled)
            .map((e) => e.label)
            .toSet())
        .union(acroNodes
            .where((element) => element.isSwitched && element.isEnabled)
            .map((e) => e.label)
            .toSet())
        .map((e) => Position(e))
        .toList());
  }

  void createPosture(Node child, String posture) {}

  void editPosture(Node child, String posture) {}

  void deletePosture(Node child) {}

  void onDeleteClick(Node child) {
    if (child.isLeaf) {
      deletePosture(child);
      return;
    }
  }

  void onSaveClick(Node child, bool isCategory, String? posture) {}

  void onEditClick(Node child, bool isCategory, String? posture) {}
}
