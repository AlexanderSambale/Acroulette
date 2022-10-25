import 'package:acroulette/models/pair.dart';
import 'package:flutter/material.dart';

class DeleteCategory extends StatelessWidget {
  const DeleteCategory({
    Key? key,
    required this.onDeleteClick,
    required this.categoryLabel,
    required this.elementsToRemove,
  }) : super(key: key);

  final void Function() onDeleteClick;
  final String categoryLabel;
  final List<Pair> elementsToRemove;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Delete category $categoryLabel'),
        content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: elementsToRemove.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: [
                        elementsToRemove[index].first as bool
                            ? const Icon(Icons.circle)
                            : const Icon(Icons.rectangle),
                        Text(elementsToRemove[index].second as String)
                      ],
                    ),
                  );
                })),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
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
