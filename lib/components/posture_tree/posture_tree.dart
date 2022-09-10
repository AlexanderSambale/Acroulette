import 'package:acroulette/components/posture_tree/posture_category_item.dart';
import 'package:acroulette/components/posture_tree/posture_list_item.dart';
import 'package:acroulette/main.dart';
import 'package:acroulette/models/node.dart';
import 'package:flutter/material.dart';

class PostureTree extends StatelessWidget {
  const PostureTree({super.key, required this.tree});

  final Node tree;

  @override
  Widget build(BuildContext context) {
    if (tree.isLeaf) {
      return Container(
          margin: const EdgeInsets.only(left: 24),
          child: PostureListItem(
              isSwitched: tree.value.target!.isSwitched,
              postureLabel: tree.value.target!.label,
              onChanged: (bool switched) {
                tree.value.target!.isSwitched = switched;
                objectbox.putAcroNode(tree.value.target!);
                objectbox.putNode(tree);
              },
              delete: () {}));
    } else {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: tree.children.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return PostureCategoryItem(
                  categoryLabel: tree.value.target!.label,
                  isSwitched: tree.value.target!.isSwitched,
                  onChanged: (bool switched) {
                    tree.value.target!.isSwitched = switched;
                    objectbox.putAcroNode(tree.value.target!);
                    objectbox.putNode(tree);
                  },
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
