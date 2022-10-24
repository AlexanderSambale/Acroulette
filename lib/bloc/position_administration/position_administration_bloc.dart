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
      : super(PositionAdministrationInitialState(objectbox.findRoot())) {
    tree = state.tree;

    on<PositionsBDStartChangeEvent>((event, emit) {
      emit(PositionAdministrationState(tree));
    });
    on<PositionsDBIsChangingEvent>((event, emit) {
      emit(PositionAdministrationState(tree));
    });
    on<PositionsDBIsIdleEvent>((event, emit) {
      emit(PositionAdministrationInitialState.withTree(objectbox.findRoot()));
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

  void createPosture(Node parent, String posture) {
    add(PositionsBDStartChangeEvent());
    AcroNode acroNode = AcroNode(true, posture);
    Node newPosture = Node.createLeaf(acroNode);
    parent.addNode(newPosture);
    objectbox.putAcroNode(acroNode);
    objectbox.putNode(parent);
    regeneratePositionsList([acroNode]);
    add(PositionsDBIsIdleEvent());
  }

  void editPosture(Node child, String posture) {
    add(PositionsBDStartChangeEvent());
    AcroNode acroNode = child.value.target!;
    acroNode.label = posture;
    objectbox.putAcroNode(acroNode);
    regeneratePositionsList([acroNode]);
    add(PositionsDBIsIdleEvent());
  }

  void deletePosture(Node child) {
    add(PositionsBDStartChangeEvent());
    Node parent = objectbox.findParent(child);
    AcroNode acroNode = child.value.target!;
    parent.children.remove(child);
    objectbox.putNode(parent);
    objectbox.removeNode(child);
    objectbox.removeAcroNode(acroNode);
    regeneratePositionsList([acroNode]);
    add(PositionsDBIsIdleEvent());
  }

  void onDeleteClick(Node child) {
    if (child.isLeaf) {
      deletePosture(child);
      return;
    }
  }

  void onSaveClick(Node parent, bool isCategory, String? posture) {
    if (posture == null) return;
    createPosture(parent, posture);
  }

  void onEditClick(Node child, bool isCategory, String? posture) {
    if (posture == null) return;
    editPosture(child, posture);
  }
}
