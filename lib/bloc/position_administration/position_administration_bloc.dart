import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/pair.dart';
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
    regeneratePositionsList();
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

  void regeneratePositionsList() {
    List<Node> nodes = objectbox.nodeBox.getAll();
    Set<String> setOfPositions = {};
    setOfPositions.addAll(
        nodes.where((element) => element.isLeaf).map<String>((e) => e.label!));
    objectbox.positionBox.removeAll();
    objectbox.positionBox
        .putMany(setOfPositions.map((e) => Position(e)).toList());
  }

  void createPosture(Node parent, String posture) {
    add(PositionsBDStartChangeEvent());
    AcroNode acroNode = AcroNode(true, posture);
    Node newPosture = Node.createLeaf(acroNode);
    parent.addNode(newPosture);
    objectbox.putAcroNode(acroNode);
    objectbox.putNode(parent);
    regeneratePositionsList();
    add(PositionsDBIsIdleEvent());
  }

  void editAcroNode(Node child, String label) {
    add(PositionsBDStartChangeEvent());
    AcroNode acroNode = child.value.target!;
    acroNode.label = label;
    objectbox.putAcroNode(acroNode);
    regeneratePositionsList();
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
    regeneratePositionsList();
    add(PositionsDBIsIdleEvent());
  }

  List<Node> getAllChildrenRecursive(Node child) {
    List<Node> allNodes = child.children;
    for (var childOfChild in child.children) {
      allNodes.addAll(getAllChildrenRecursive(childOfChild));
    }
    return allNodes;
  }

  /// Returns a list of Pairs
  /// Here a pair is true, if it is a posture. If it is a category, it is false.
  /// The second property here is just a label for the posture/category.
  List<Pair> listElementsToRemove(Node root) {
    List<Pair> pairs = [Pair(root.isLeaf, root.label)];
    for (var child in root.children) {
      pairs.addAll(listElementsToRemove(child));
    }
    return pairs;
  }

  void deleteCategory(Node child) {
    add(PositionsBDStartChangeEvent());
    List<Node> toRemove = getAllChildrenRecursive(child)..add(child);
    List<AcroNode> toRemoveAcro =
        toRemove.map<AcroNode>((element) => element.value.target!).toList();
    objectbox.removeManyAcroNodes(toRemoveAcro);
    objectbox.removeManyNodes(toRemove);
    regeneratePositionsList();
    add(PositionsDBIsIdleEvent());
  }

  void createCategory(Node parent, String category) {
    add(PositionsBDStartChangeEvent());
    AcroNode acroNode = AcroNode(true, category);
    Node newPosture = Node.createCategory([], acroNode);
    parent.addNode(newPosture);
    objectbox.putAcroNode(acroNode);
    objectbox.putNode(parent);
    regeneratePositionsList();
    add(PositionsDBIsIdleEvent());
  }

  void onDeleteClick(Node child) {
    if (child.isLeaf) {
      deletePosture(child);
      return;
    }
    deleteCategory(child);
  }

  void onSaveClick(Node parent, bool isPosture, String? label) {
    if (label == null) return;
    if (isPosture) {
      createPosture(parent, label);
      return;
    }
    createCategory(parent, label);
  }

  void onEditClick(Node child, bool isPosture, String? label) {
    if (label == null) return;
    editAcroNode(child, label);
  }
}
