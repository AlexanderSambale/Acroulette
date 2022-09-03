import 'package:flutter/material.dart';

class PostureCategoryItem extends StatefulWidget {
  const PostureCategoryItem(
      {super.key,
      required this.isSwitched,
      required this.isExpanded,
      required this.categoryLabel});

  final bool isSwitched;
  final bool isExpanded;
  final String categoryLabel;

  @override
  State<PostureCategoryItem> createState() => PostureCategoryItemState();
}

class PostureCategoryItemState extends State<PostureCategoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: Row(
          children: [
            Icon(widget.isExpanded ? Icons.expand_less : Icons.expand_more),
            Center(child: Text(widget.categoryLabel)),
            Switch(
                value: widget.isSwitched,
                onChanged: (value) {
                  setState(() {});
                }),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete position',
              onPressed: () {
                setState(() {});
              },
            )
          ],
        ));
  }
}
