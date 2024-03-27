import 'package:acroulette/models/pair.dart';
import 'package:flutter/material.dart';

class DeleteCategory extends StatelessWidget {
  const DeleteCategory({
    super.key,
    required this.onDeleteClick,
    required this.path,
    required this.elementsToRemove,
  });

  final void Function() onDeleteClick;
  final List<String> path;
  final List<Pair> elementsToRemove;

  @override
  Widget build(BuildContext context) {
    List<String> reducedPath = path.toList();
    String categoryLabel = reducedPath.last;
    reducedPath.removeLast();
    return AlertDialog(
        title: Text('Delete category $categoryLabel'),
        content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: elementsToRemove.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Text(
                      'Delete $categoryLabel from ${reducedPath.join(" >> ")} will delete:');
                }
                return Card(
                  child: Row(
                    children: [
                      elementsToRemove[index - 1].first as bool
                          ? const Icon(Icons.circle)
                          : const Icon(Icons.rectangle),
                      Container(
                        width: 10,
                      ),
                      Text(elementsToRemove[index - 1].second as String)
                    ],
                  ),
                );
              },
            )),
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
