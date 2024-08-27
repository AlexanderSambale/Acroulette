import 'package:acroulette/helper/widgets/action_pane.dart';
import 'package:acroulette/widgets/dialogs/flow_dialog/show_edit_flow_dialog.dart';
import 'package:acroulette/widgets/dialogs/posture_dialog/create_posture_dialog.dart';
import 'package:acroulette/widgets/formWidgets/icon_button.dart';
import 'package:acroulette/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FlowItem extends StatelessWidget {
  const FlowItem({
    super.key,
    required this.onEditClick,
    required this.showDeleteFlowDialog,
    required this.onSavePostureClick,
    required this.flowLabel,
    this.validator,
  });

  final String flowLabel;
  final void Function(String?) onSavePostureClick;
  final void Function(String?) onEditClick;
  final dynamic Function(BuildContext context) showDeleteFlowDialog;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    const double size = 32;
    const double padding = 4;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: size,
          child: ClipRRect(
            child: Slidable(
              key: Key(flowLabel),
              startActionPane: ActionPane(
                extentRatio: calculateExtentRatio(
                  size: size,
                  padding: padding,
                  maxWidth: constraints.maxWidth,
                  numberOfWidgets: 2,
                ),
                motion: const ScrollMotion(),
                children: [
                  createIconButton(
                    padding: padding,
                    context: context,
                    size: size,
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit flow name',
                    onPressed: () => showEditFlowDialog(
                      context,
                      flowLabel,
                      onEditClick,
                      validator,
                    ),
                  ),
                  createIconButton(
                    padding: padding,
                    context: context,
                    size: size,
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
                ],
              ),
              endActionPane: ActionPane(
                extentRatio: calculateExtentRatio(
                  size: size,
                  padding: padding,
                  maxWidth: constraints.maxWidth,
                  numberOfWidgets: 1,
                ),
                motion: const ScrollMotion(),
                children: [
                  const Spacer(),
                  createIconButton(
                    padding: padding,
                    context: context,
                    size: size,
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete flow',
                    onPressed: () => showDeleteFlowDialog(context),
                  )
                ],
              ),
              child: Row(
                children: [
                  categoryIcon,
                  Container(
                    width: 10,
                  ),
                  Center(child: Text(flowLabel)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
