import 'package:flutter/material.dart';

class PostureListItem extends StatelessWidget {
  const PostureListItem(
      {super.key,
      required this.isSwitched,
      required this.postureLabel,
      required this.onChanged,
      required this.delete});

  final bool isSwitched;
  final String postureLabel;
  final void Function(bool) onChanged;
  final void Function() delete;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: Row(
          children: [
            Center(child: Text(postureLabel)),
            Switch(value: isSwitched, onChanged: onChanged),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete position',
              onPressed: delete,
            )
          ],
        ));
  }
}
