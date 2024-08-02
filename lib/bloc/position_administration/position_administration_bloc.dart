import 'package:acroulette/constants/validator.dart';
import 'package:acroulette/helper/objectbox/to_many_extension.dart';
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
      AcroNode acroNode = node.acroNode.value!;
      if (acroNode.isSwitched) {
        enableOrDisableAndAddAcroNodes(acroNodes, node, isSwitched);
      }
      acroNode.isEnabled = isSwitched;
      acroNodes.add(acroNode);
    }
  }

  void onSwitch(bool switched, Node tree) {
    add(PositionsBDStartChangeEvent());
    AcroNode acroNode = tree.acroNode.value!;
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
    dbController.createPosture(parent, posture);
    add(PositionsDBIsIdleEvent());
  }

  void updateNodeLabel(Node child, String label) {
    add(PositionsBDStartChangeEvent());
    dbController.updateNodeLabel(child, label);
    add(PositionsDBIsIdleEvent());
  }

  void deletePosture(Node child) {
    add(PositionsBDStartChangeEvent());
    dbController.deletePosture(child);
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
    dbController.deleteCategory(category);
    add(PositionsDBIsIdleEvent());
  }

  void createCategory(Node? parent, String category) {
    add(PositionsBDStartChangeEvent());
    dbController.createCategory(parent, category);
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
    updateNodeLabel(child, label);
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

  Future<String?> validatorRootCategory(String? label) async {
    if (label == null || label.isEmpty) return enterText;
    List<Node> rootCategories = await dbController.findNodesWithoutParent();
    for (var category in rootCategories) {
      if (category.label == label) {
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
