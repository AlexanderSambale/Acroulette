import 'package:acroulette/constants/validator.dart';
import 'package:acroulette/helper/objectbox/to_many_extension.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/pair.dart';
import 'package:acroulette/storage_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'position_administration_event.dart';
part 'position_administration_state.dart';

class PositionAdministrationBloc
    extends Bloc<PositionAdministrationEvent, BasePositionAdministrationState> {
  PositionAdministrationBloc(this.storageProvider)
      : super(const PositionAdministrationInitialState([])) {
    on<PositionsBDStartChangeEvent>((event, emit) {
      emit(PositionAdministrationState(state.trees));
    });
    on<PositionsDBIsIdleEvent>((event, emit) {
      emit(PositionAdministrationInitialState(event.trees));
    });
  }

  late StorageProvider storageProvider;

  Future<void> onSwitch(bool switched, Node tree) async {
    add(PositionsBDStartChangeEvent());
    await storageProvider.onSwitch(switched, tree);
    add(PositionsDBIsIdleEvent(storageProvider.nodesWithoutParent));
  }

  void toggleExpand(Node tree) async {
    add(PositionsBDStartChangeEvent());
    await storageProvider.updateNodeIsExpanded(tree, !tree.isExpanded);
    add(PositionsDBIsIdleEvent(storageProvider.nodesWithoutParent));
  }

  Future<void> createPosture(Node parent, String posture) async {
    add(PositionsBDStartChangeEvent());
    await storageProvider.createPosture(parent, posture);
    add(PositionsDBIsIdleEvent(storageProvider.nodesWithoutParent));
  }

  Future<void> updateNodeLabel(Node child, String label) async {
    add(PositionsBDStartChangeEvent());
    await storageProvider.updateNodeLabel(child, label);
    add(PositionsDBIsIdleEvent(storageProvider.nodesWithoutParent));
  }

  Future<void> deletePosture(Node child) async {
    add(PositionsBDStartChangeEvent());
    await storageProvider.deletePosture(child);
    add(PositionsDBIsIdleEvent(storageProvider.nodesWithoutParent));
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
    await storageProvider.deleteCategory(category);
    add(PositionsDBIsIdleEvent(storageProvider.nodesWithoutParent));
  }

  Future<void> createCategory(Node? parent, String category) async {
    add(PositionsBDStartChangeEvent());
    await storageProvider.createCategory(parent, category);
    add(PositionsDBIsIdleEvent(storageProvider.nodesWithoutParent));
  }

  Future<void> onDeleteClick(Node child) async {
    if (child.isLeaf) {
      await deletePosture(child);
      return;
    }
    await deleteCategory(child);
  }

  Future<void> onSaveClick(Node? parent, bool isPosture, String? label) async {
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

  Future<void> onEditClick(Node child, bool isPosture, String? label) async {
    if (label == null || label.isEmpty) return;
    await updateNodeLabel(child, label);
  }

  String? validatorPosture(Node parent, String label) {
    if (parent.children.containsElementWithLabel(true, label)) {
      return existsText('Posture', label);
    }
    return null;
  }

  String? validatorCategory(Node category, String label) {
    Node? parent = category.parent;
    if (parent == null) return null;
    if (parent.children.containsElementWithLabel(false, label)) {
      return existsText('Category', label);
    }
    return null;
  }

  String? validatorRootCategory(String? label) {
    if (label == null || label.isEmpty) return enterText;
    List<Node> rootCategories = storageProvider.nodesWithoutParent;
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
