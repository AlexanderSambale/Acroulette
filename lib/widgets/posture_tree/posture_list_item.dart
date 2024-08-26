import 'package:acroulette/helper/widgets/action_pane.dart';
import 'package:acroulette/widgets/dialogs/posture_dialog/edit_posture_dialog.dart';
import 'package:acroulette/widgets/formWidgets/icon_button.dart';
import 'package:acroulette/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PostureListItem extends StatelessWidget {
  const PostureListItem(
      {super.key,
      required this.isSwitched,
      required this.postureLabel,
      required this.onChanged,
      required this.onEditClick,
      required this.showDeletePositionDialog,
      required this.path,
      this.validator,
      this.enabled = true});

  final bool isSwitched;
  final bool enabled;
  final String postureLabel;
  final void Function(bool) onChanged;
  final void Function(String?) onEditClick;
  final void Function(BuildContext) showDeletePositionDialog;
  final List<String> path;
  final String? Function(bool, String?)? validator;

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
              key: Key(postureLabel),
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
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EditPosture(
                                path: path,
                                onEditClick: onEditClick,
                                validator: (posture) {
                                  if (validator == null) return null;
                                  return validator!(true, posture);
                                });
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
                    tooltip: 'Delete position',
                    onPressed: () => showDeletePositionDialog(context),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 5,
                  ),
                  postureIcon,
                  Container(
                    width: 10,
                  ),
                  Center(child: Text(postureLabel)),
                  const Spacer(),
                  createSwitch(
                    size: size,
                    isSwitched: isSwitched,
                    enabled: enabled,
                    onChanged: onChanged,
                    context: context,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
