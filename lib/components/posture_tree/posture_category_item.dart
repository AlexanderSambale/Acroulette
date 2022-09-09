import 'package:flutter/material.dart';

class PostureCategoryItem extends StatelessWidget {
  const PostureCategoryItem(
      {super.key,
      required this.isSwitched,
      required this.isExpanded,
      required this.categoryLabel});

  final bool isSwitched;
  final bool isExpanded;
  final String categoryLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: Row(
          children: [
            IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              tooltip: isExpanded ? 'collapse' : 'expand',
              onPressed: () {},
            ),
            Center(child: Text(categoryLabel)),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add_circle_rounded),
              tooltip: 'Add position',
              onPressed: () {},
            ),
            Switch(value: isSwitched, onChanged: (value) {}),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete position',
              onPressed: () {},
            )
          ],
        ));
  }
}
