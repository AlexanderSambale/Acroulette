import 'package:acroulette/widgets/dialogs/posture_dialog/show_delete_posture_dialog.dart';
import 'package:acroulette/widgets/posture_tree/posture_category_item.dart';
import 'package:acroulette/widgets/posture_tree/posture_list_item.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/models/pair.dart';
import 'package:flutter/material.dart';

class PostureTree extends StatelessWidget {
  const PostureTree(
      {super.key,
      required this.tree,
      required this.onSwitched,
      required this.toggleExpand,
      required this.onSaveClick,
      required this.onEditClick,
      required this.onDeleteClick,
      required this.path,
      required this.listAllNodesRecursively,
      this.validator});

  final Node tree;
  final void Function(bool, Node) onSwitched;
  final void Function(Node) toggleExpand;
  final void Function(Node, bool, String?) onSaveClick;
  final void Function(Node, bool, String?) onEditClick;
  final String? Function(Node, bool, String?)? validator;
  final void Function(Node) onDeleteClick;
  final List<Pair> Function(Node) listAllNodesRecursively;
  final List<String> path;

  @override
  Widget build(BuildContext context) {
    var newPath = path.toList();
    newPath.add(tree.label);
    if (tree.isLeaf) {
      return Container(
          margin: const EdgeInsets.only(left: 16),
          child: PostureListItem(
              isSwitched: tree.isSwitched,
              postureLabel: tree.label,
              onChanged: (isOn) => onSwitched(isOn, tree),
              onEditClick: (String? value) => onEditClick(tree, false, value),
              showDeletePositionDialog: (context) => showDeletePositionDialog(
                    context,
                    newPath,
                    () => onDeleteClick(tree),
                  ),
              path: newPath,
              enabled: tree.isEnabled));
    }
    return ExpansionTile(
      title: PostureCategoryItem(
        categoryLabel: tree.label,
        isSwitched: tree.isSwitched,
        onChanged: (isOn) => onSwitched(isOn, tree),
        onEditClick: (String? value) => onEditClick(tree, false, value),
        onDeleteClick: () => onDeleteClick(tree),
        onSaveClick: (bool isPosture, String? value) =>
            onSaveClick(tree, isPosture, value),
        enabled: tree.isEnabled,
        path: newPath,
        listAllNodesRecursively: () => listAllNodesRecursively(tree),
        validator: (bool isPosture, String? value) {
          if (validator == null) return null;
          return validator!(tree, isPosture, value);
        },
      ),
      onExpansionChanged: (value) {
        toggleExpand(tree);
      },
      initiallyExpanded: tree.isExpanded,
      controlAffinity: ListTileControlAffinity.leading,
      children: tree.children.map((Node child) {
        return Container(
          margin: const EdgeInsets.only(left: 24),
          child: PostureTree(
              tree: child,
              onSwitched: onSwitched,
              toggleExpand: toggleExpand,
              onEditClick: onEditClick,
              onDeleteClick: onDeleteClick,
              onSaveClick: onSaveClick,
              path: newPath,
              listAllNodesRecursively: listAllNodesRecursively,
              validator: validator),
        );
      }).toList(),
    );
  }
}
