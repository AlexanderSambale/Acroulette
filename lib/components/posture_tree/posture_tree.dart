import 'package:acroulette/components/posture_tree/posture_category_item.dart';
import 'package:acroulette/components/posture_tree/posture_list_item.dart';
import 'package:acroulette/models/node.dart';
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
      required this.path});

  final Node tree;
  final void Function(bool, Node) onSwitched;
  final void Function(Node) toggleExpand;
  final void Function(Node, bool, String?) onSaveClick;
  final void Function(Node, bool, String?) onEditClick;
  final void Function(Node) onDeleteClick;
  final List<String> path;

  @override
  Widget build(BuildContext context) {
    var newPath = path.toList();
    newPath.add(tree.label!);
    if (tree.isLeaf) {
      return Container(
          margin: const EdgeInsets.only(left: 24),
          child: PostureListItem(
              isSwitched: tree.value.target!.isSwitched,
              postureLabel: tree.label!,
              onChanged: (isOn) => onSwitched(isOn, tree),
              onEditClick: (String? value) => onEditClick(tree, false, value),
              onDeleteClick: () => onDeleteClick(tree),
              path: newPath,
              enabled: tree.value.target!.isEnabled));
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: tree.children.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return PostureCategoryItem(
              categoryLabel: tree.label!,
              isSwitched: tree.value.target!.isSwitched,
              onChanged: (isOn) => onSwitched(isOn, tree),
              onEditClick: (bool isCategory, String? value) =>
                  onEditClick(tree, isCategory, value),
              onDeleteClick: () => onDeleteClick(tree),
              onSaveClick: (bool isCategory, String? value) =>
                  onSaveClick(tree, isCategory, value),
              toggleExpand: () => toggleExpand(tree),
              isExpanded: tree.isExpanded,
              enabled: tree.value.target!.isEnabled,
              path: newPath,
            );
          }
          if (tree.isExpanded) {
            return Container(
                margin: const EdgeInsets.only(left: 24),
                child: PostureTree(
                  tree: tree.children.elementAt(index - 1),
                  onSwitched: onSwitched,
                  toggleExpand: toggleExpand,
                  onEditClick: onEditClick,
                  onDeleteClick: onDeleteClick,
                  onSaveClick: onSaveClick,
                  path: newPath,
                ));
          }
          return Container();
        });
  }
}
