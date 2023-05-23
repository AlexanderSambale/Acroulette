import 'package:acroulette/widgets/dialogs/flow_dialog/show_edit_flow_dialog.dart';
import 'package:acroulette/widgets/dialogs/posture_dialog/create_posture_dialog.dart';
import 'package:acroulette/widgets/icons/icons.dart';
import 'package:flutter/material.dart';

class FlowItem extends StatelessWidget {
  const FlowItem({
    super.key,
    required this.isExpanded,
    required this.onEditClick,
    required this.showDeleteFlowDialog,
    required this.onSavePostureClick,
    required this.toggleExpand,
    required this.flowLabel,
    this.validator,
  });

  final bool isExpanded;
  final String flowLabel;
  final void Function(String?) onSavePostureClick;
  final void Function(String?) onEditClick;
  final dynamic Function(BuildContext context) showDeleteFlowDialog;
  final void Function() toggleExpand;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: Row(
          children: [
            IconButton(
              constraints: const BoxConstraints(minWidth: 32),
              padding: const EdgeInsets.all(0),
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              tooltip: isExpanded ? 'collapse' : 'expand',
              onPressed: toggleExpand,
            ),
            categoryIcon,
            Container(
              width: 10,
            ),
            Center(child: Text(flowLabel)),
            const Spacer(),
            IconButton(
              constraints: const BoxConstraints(minWidth: 32),
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.add_circle_rounded),
              tooltip: 'Add position',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CreatePosture(
                        path: [flowLabel],
                        onSaveClick: onSavePostureClick,
                      );
                    }).then((exit) {
                  if (exit) return;
                });
              },
            ),
            IconButton(
              constraints: const BoxConstraints(minWidth: 32),
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.edit),
              tooltip: 'Edit flow name',
              onPressed: () => showEditFlowDialog(
                  context, flowLabel, onEditClick, validator),
            ),
            IconButton(
              constraints: const BoxConstraints(minWidth: 32),
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.delete),
              tooltip: 'Delete flow',
              onPressed: () => showDeleteFlowDialog(context),
            )
          ],
        ));
  }
}
