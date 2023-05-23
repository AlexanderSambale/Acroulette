import 'package:acroulette/widgets/icons/icons.dart';
import 'package:flutter/material.dart';

class FlowPositionItem extends StatelessWidget {
  const FlowPositionItem(
      {super.key,
      required this.positionLabel,
      required this.showEditPositionDialog,
      required this.showDeletePositionDialog});

  final String positionLabel;
  final void Function(BuildContext) showEditPositionDialog;
  final void Function(BuildContext) showDeletePositionDialog;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SizedBox(
            height: 50,
            child: Row(
              children: [
                postureIcon,
                Container(
                  width: 10,
                ),
                Center(child: Text(positionLabel)),
                const Spacer(),
                IconButton(
                  constraints: const BoxConstraints(minWidth: 32),
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit position',
                  onPressed: () => showEditPositionDialog(context),
                ),
                IconButton(
                  constraints: const BoxConstraints(minWidth: 32),
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete position',
                  onPressed: () => showDeletePositionDialog(context),
                )
              ],
            )));
  }
}
