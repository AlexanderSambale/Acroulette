import 'package:flutter/material.dart';

class DeleteFlow extends StatelessWidget {
  const DeleteFlow({
    Key? key,
    required this.onDeleteClick,
    required this.flowLabel,
    required this.elementsToRemove,
  }) : super(key: key);

  final void Function() onDeleteClick;
  final String flowLabel;
  final List<String> elementsToRemove;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Delete flow $flowLabel.'),
        content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: elementsToRemove.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Card(
                      child: Row(
                        children: [
                          const Icon(Icons.rectangle),
                          Container(
                            width: 10,
                          ),
                          Text(flowLabel),
                        ],
                      ),
                    );
                  }
                  return Card(
                    child: Row(
                      children: [
                        const Icon(Icons.circle),
                        Container(
                          width: 10,
                        ),
                        Text(elementsToRemove[index - 1])
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
