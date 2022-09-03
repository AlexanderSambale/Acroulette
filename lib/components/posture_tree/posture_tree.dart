import 'dart:collection';

import 'package:flutter/material.dart';



class PostureTree extends StatelessWidget {
  const PostureTree({super.key, required this.tree});

  final LinkedHashSet< tree;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: Row(
          children: [
            Center(child: Text(postureLabel)),
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
