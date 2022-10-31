import 'package:acroulette/components/dialogs/posture_dialog/create_posture_dialog.dart';
import 'package:acroulette/components/dialogs/posture_dialog/edit_posture_dialog.dart';
import 'package:acroulette/components/icons/icons.dart';
import 'package:flutter/material.dart';

class FlowItem extends StatelessWidget {
  const FlowItem({
    super.key,
    required this.isExpanded,
    required this.onEditClick,
    required this.showDeleteFlowDialog,
    required this.onSaveClick,
    required this.toggleExpand,
    required this.flowLabel,
  });

  final bool isExpanded;
  final String flowLabel;
  final void Function(bool, String?) onSaveClick;
  final void Function(String?) onEditClick;
  final dynamic Function(BuildContext context) showDeleteFlowDialog;
  final void Function() toggleExpand;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: Row(
          children: [
            IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              tooltip: isExpanded ? 'collapse' : 'expand',
              onPressed: toggleExpand,
            ),
            Container(
              width: 10,
            ),
            categoryIcon,
            Container(
              width: 10,
            ),
            Center(child: Text(flowLabel)),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add_circle_rounded),
              tooltip: 'Add position',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CreatePosture(
                        path: [flowLabel],
                        onSaveClick: (flow) => onSaveClick(true, flow),
                      );
                    }).then((exit) {
                  if (exit) return;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit flow name',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditPosture(
                          path: [flowLabel], onEditClick: onEditClick);
                    }).then((exit) {
                  if (exit) return;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete flow',
              onPressed: () => showDeleteFlowDialog(context),
            )
          ],
        ));
  }
}
