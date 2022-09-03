import 'package:flutter/material.dart';

class PostureListItem extends StatelessWidget {
  const PostureListItem(
      {super.key, required this.isSwitched, required this.postureLabel});

  final bool isSwitched;
  final String postureLabel;

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
