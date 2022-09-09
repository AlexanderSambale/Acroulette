import 'package:acroulette/components/posture_tree/posture_category_item.dart';
import 'package:acroulette/components/posture_tree/posture_list_item.dart';
import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:flutter/material.dart';

class PostureTree extends StatelessWidget {
  const PostureTree({super.key, required this.tree});

  final Node<AcroNode> tree;

  @override
  Widget build(BuildContext context) {
    if (tree.isLeaf) {
      if (tree.value == null) {
        return Container();
      } else {
        return Container(
            margin: const EdgeInsets.only(left: 24),
            child: PostureListItem(
                isSwitched: tree.value!.isSwitched,
                postureLabel: tree.value!.label,
                onChanged: tree.value!.onSwitchChange,
                delete: tree.value!.delete));
      }
    } else {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: tree.children.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return PostureCategoryItem(
                  categoryLabel: tree.value!.label,
                  isSwitched: tree.value!.isSwitched,
                  isExpanded: true);
            } else {
              return Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: PostureTree(tree: tree.children.elementAt(index - 1)));
            }
          });
    }
  }
}
