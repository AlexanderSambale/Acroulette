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
      : super(const PositionAdministrationInitialState([])) {
    on<PositionsBDStartChangeEvent>((event, emit) {
      emit(PositionAdministrationState(state.trees));
    });
    on<PositionsDBIsIdleEvent>((event, emit) {
      emit(PositionAdministrationInitialState(event.trees));
    });
  }

  late DBController dbController;

  Future<void> onSwitch(bool switched, Node tree) async {
    add(PositionsBDStartChangeEvent());
    await dbController.onSwitch(switched, tree);
    add(PositionsDBIsIdleEvent(await dbController.findNodesWithoutParent()));
  }

  void toggleExpand(Node tree) async {
    add(PositionsBDStartChangeEvent());
    tree.isExpanded = !tree.isExpanded;
    await dbController.putNode(tree);
    add(PositionsDBIsIdleEvent(await dbController.findNodesWithoutParent()));
  }

  Future<void> createPosture(Node parent, String posture) async {
    add(PositionsBDStartChangeEvent());
    await dbController.createPosture(parent, posture);
    add(PositionsDBIsIdleEvent(await dbController.findNodesWithoutParent()));
  }

  Future<void> updateNodeLabel(Node child, String label) async {
    add(PositionsBDStartChangeEvent());
    await dbController.updateNodeLabel(child, label);
    add(PositionsDBIsIdleEvent(await dbController.findNodesWithoutParent()));
  }

  Future<void> deletePosture(Node child) async {
    add(PositionsBDStartChangeEvent());
    await dbController.deletePosture(child);
    add(PositionsDBIsIdleEvent(await dbController.findNodesWithoutParent()));
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

  Future<void> deleteCategory(Node category) async {
    add(PositionsBDStartChangeEvent());
    await dbController.deleteCategory(category);
    add(PositionsDBIsIdleEvent(await dbController.findNodesWithoutParent()));
  }

  Future<void> createCategory(Node? parent, String category) async {
    add(PositionsBDStartChangeEvent());
    await dbController.createCategory(parent, category);
    add(PositionsDBIsIdleEvent(await dbController.findNodesWithoutParent()));
  }

  void onDeleteClick(Node child) async {
    if (child.isLeaf) {
      await deletePosture(child);
      return;
    }
    await deleteCategory(child);
  }

  void onSaveClick(Node? parent, bool isPosture, String? label) async {
    if (label == null || label.isEmpty) return;
    if (isPosture) {
      if (parent == null) {
        throw Exception("Creating a posture without parent is not allowed!");
      }
      await createPosture(parent, label);
      return;
    }
    await createCategory(parent, label);
  }

  void onEditClick(Node child, bool isPosture, String? label) async {
    if (label == null || label.isEmpty) return;
    await updateNodeLabel(child, label);
  }

  String? validatorPosture(Node parent, String label) {
    if (parent.children.containsElementWithLabel(true, label)) {
      return existsText('Posture', label);
    }
    return null;
  }

  Future<String?> validatorCategory(Node category, String label) async {
    Node? parent = await dbController.findParent(category);
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

  Future<String?> validator(
      Node category, bool isPosture, String? label) async {
    if (label == null || label.isEmpty) {
      return enterText;
    }
    return isPosture
        ? validatorPosture(category, label)
        : await validatorCategory(category, label);
  }
}
