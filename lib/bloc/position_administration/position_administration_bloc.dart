import 'package:acroulette/constants/validator.dart';
import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/pair.dart';
import 'package:acroulette/db_controller.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'position_administration_event.dart';
part 'position_administration_state.dart';

class PositionAdministrationBloc
    extends Bloc<PositionAdministrationEvent, BasePositionAdministrationState> {
  PositionAdministrationBloc(this.dbController)
      : super(PositionAdministrationInitialState(
            dbController.findNodesWithoutParent())) {
    on<PositionsBDStartChangeEvent>((event, emit) {
      emit(PositionAdministrationState(state.trees));
    });
    on<PositionsDBIsIdleEvent>((event, emit) {
      emit(PositionAdministrationInitialState(
          dbController.findNodesWithoutParent()));
    });
  }

  late DBController dbController;

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
    acroNodes.add(acroNode);

    dbController.putManyAcroNodes(acroNodes);
    dbController.putNode(tree);
    regeneratePositionsList();
    add(PositionsDBIsIdleEvent());
  }

  void toggleExpand(Node tree) {
    add(PositionsBDStartChangeEvent());
    tree.isExpanded = !tree.isExpanded;
    dbController.putNode(tree);
    add(PositionsDBIsIdleEvent());
  }

  void regeneratePositionsList() {
    dbController.regeneratePositionsList();
  }

  void createPosture(Node parent, String posture) {
    add(PositionsBDStartChangeEvent());
    AcroNode acroNode = AcroNode(true, posture);
    Node newPosture = Node.createLeaf(parent: parent, acroNode);
    parent.addNode(newPosture);
    dbController.putNode(parent);
    regeneratePositionsList();
    add(PositionsDBIsIdleEvent());
  }

  void editAcroNode(Node child, String label) {
    add(PositionsBDStartChangeEvent());
    AcroNode acroNode = child.value.target!;
    acroNode.label = label;
    dbController.putAcroNode(acroNode);
    regeneratePositionsList();
    add(PositionsDBIsIdleEvent());
  }

  void deletePosture(Node child) {
    add(PositionsBDStartChangeEvent());
    Node? parent = dbController.findParent(child);
    AcroNode acroNode = child.value.target!;
    if (parent != null) {
      parent.children.remove(child);
      dbController.putNode(parent);
    }
    dbController.removeNode(child);
    dbController.removeAcroNode(acroNode);
    regeneratePositionsList();
    add(PositionsDBIsIdleEvent());
  }

  /// Returns a list of Pairs
  /// Here a pair is true, if it is a posture. If it is a category, it is false.
  /// The second property here is just a label for the posture/category.
  List<Pair> listAllNodesRecursively(Node root) {
    List<Pair> pairs = [Pair(root.isLeaf, root.label)];
    for (var child in root.children) {
      pairs.addAll(listAllNodesRecursively(child));
    }
    return pairs;
  }

  void deleteCategory(Node category) {
    add(PositionsBDStartChangeEvent());
    List<Node> toRemove = dbController.getAllChildrenRecursive(category)
      ..add(category);
    List<AcroNode> toRemoveAcro =
        toRemove.map<AcroNode>((element) => element.value.target!).toList();
    Node? parent = dbController.findParent(category);
    if (parent != null) {
      parent.children.remove(category);
      dbController.putNode(parent);
    }
    dbController.removeManyAcroNodes(toRemoveAcro);
    dbController.removeManyNodes(toRemove);
    regeneratePositionsList();
    add(PositionsDBIsIdleEvent());
  }

  void createCategory(Node? parent, String category) {
    add(PositionsBDStartChangeEvent());
    AcroNode acroNode = AcroNode(true, category);
    Node newPosture = Node.createCategory(parent: parent, [], acroNode);
    if (parent != null) {
      parent.addNode(newPosture);
      dbController.putNode(parent);
    } else {
      dbController.putNode(newPosture);
    }
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

  void onSaveClick(Node? parent, bool isPosture, String? label) {
    if (label == null || label.isEmpty) return;
    if (isPosture) {
      if (parent == null) {
        throw Exception("Creating a posture without parent is not allowed!");
      }
      createPosture(parent, label);
      return;
    }
    createCategory(parent, label);
  }

  void onEditClick(Node child, bool isPosture, String? label) {
    if (label == null || label.isEmpty) return;
    editAcroNode(child, label);
  }

  String? validatorPosture(Node parent, String label) {
    if (parent.children.containsElementWithLabel(true, label)) {
      return existsText('Posture', label);
    }
    return null;
  }

  String? validatorCategory(Node category, String label) {
    Node? parent = dbController.findParent(category);
    if (parent == null) return null;
    if (parent.children.containsElementWithLabel(false, label)) {
      return existsText('Category', label);
    }
    return null;
  }

  String? validatorRootCategory(String? label) {
    if (label == null || label.isEmpty) return enterText;
    List<Node> rootCategories = dbController.findNodesWithoutParent();
    for (var category in rootCategories) {
      if (category.value.target!.label == label) {
        return existsText('Category', label);
      }
    }
    return null;
  }

  String? validator(Node category, bool isPosture, String? label) {
    if (label == null || label.isEmpty) {
      return enterText;
    }
    return isPosture
        ? validatorPosture(category, label)
        : validatorCategory(category, label);
  }
}
