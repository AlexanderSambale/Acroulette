import 'package:acroulette/helper/widgets/action_pane.dart';
import 'package:acroulette/widgets/formWidgets/icon_button.dart';
import 'package:acroulette/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
    const double size = 32;
    const double padding = 4;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: size,
          child: ClipRRect(
            child: Slidable(
              key: Key(positionLabel),
              startActionPane: ActionPane(
                extentRatio: calculateExtentRatio(
                  size: size,
                  padding: padding,
                  maxWidth: constraints.maxWidth,
                  numberOfWidgets: 1,
                ),
                motion: const ScrollMotion(),
                children: [
                  createIconButton(
                    padding: padding,
                    context: context,
                    size: size,
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit position',
                    onPressed: () => showEditPositionDialog(context),
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
                  createIconButton(
                    padding: padding,
                    context: context,
                    size: size,
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete position',
                    onPressed: () => showDeletePositionDialog(context),
                  ),
                ],
              ),
              child: Row(
                children: [
                  postureIcon,
                  Container(
                    width: 10,
                  ),
                  Center(child: Text(positionLabel)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
