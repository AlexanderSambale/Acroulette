import 'package:acroulette/components/posture_tree/posture_category_item.dart';
import 'package:acroulette/components/posture_tree/posture_list_item.dart';
import 'package:acroulette/models/node.dart';
import 'package:flutter/material.dart';

class PostureTree extends StatelessWidget {
  const PostureTree(
      {super.key,
      required this.tree,
      required this.onSwitched,
      required this.toggleExpand});

  final Node tree;
  final void Function(bool, Node) onSwitched;
  final void Function(Node) toggleExpand;

  @override
  Widget build(BuildContext context) {
    if (tree.isLeaf) {
      return Container(
          margin: const EdgeInsets.only(left: 24),
          child: PostureListItem(
              isSwitched: tree.value.target!.isSwitched,
              postureLabel: tree.value.target!.label,
              onChanged: (isOn) => onSwitched(isOn, tree),
              delete: () {}));
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: tree.children.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return PostureCategoryItem(
                categoryLabel: tree.value.target!.label,
                isSwitched: tree.value.target!.isSwitched,
                onChanged: (isOn) => onSwitched(isOn, tree),
                toggleExpand: () => toggleExpand(tree),
                isExpanded: tree.isExpanded);
          }
          if (tree.isExpanded) {
            return Container(
                margin: const EdgeInsets.only(left: 24),
                child: PostureTree(
                    tree: tree.children.elementAt(index - 1),
                    onSwitched: onSwitched,
                    toggleExpand: toggleExpand));
          }
          return Container();
        });
  }
}
