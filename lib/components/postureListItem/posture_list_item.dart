import 'package:flutter/material.dart';

class PostureListItem extends StatefulWidget {
  const PostureListItem({Key? key}) : super(key: key);

  @override
  State<PostureListItem> createState() => PostureListItemState();
}

class PostureListItemState extends State<PostureListItem> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: Row(
          children: [
            const Center(child: Text('Entry A')),
            Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
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
