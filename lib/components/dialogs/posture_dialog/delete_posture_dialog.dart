import 'package:flutter/material.dart';

class DeletePosture extends StatelessWidget {
  const DeletePosture({
    Key? key,
    required this.onDeleteClick,
    required this.path,
  }) : super(key: key);

  final void Function() onDeleteClick;
  final List<String> path;

  @override
  Widget build(BuildContext context) {
    List<String> reducedPath = path.toList();
    String postureLabel = reducedPath.last;
    reducedPath.removeLast();
    return AlertDialog(
        title: Text('Delete Posture $postureLabel'),
        content: Text('Delete $postureLabel from ${reducedPath.join(" >> ")}'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    onDeleteClick();
                    Navigator.pop(context, true);
                  },
                  child: const Text('Confirm'),
                )),
                Container(
                  width: 10,
                ),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Cancel'),
                )),
              ],
            ),
          ),
        ]);
  }
}
