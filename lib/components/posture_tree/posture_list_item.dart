import 'package:acroulette/components/dialogs/posture_dialog/edit_posture_dialog.dart';
import 'package:flutter/material.dart';

class PostureListItem extends StatelessWidget {
  const PostureListItem(
      {super.key,
      required this.isSwitched,
      required this.postureLabel,
      required this.onChanged,
      required this.onEditClick,
      required this.onDeleteClick,
      required this.path,
      this.enabled = true});

  final bool isSwitched;
  final bool enabled;
  final String postureLabel;
  final void Function(bool) onChanged;
  final void Function(String?) onEditClick;
  final void Function() onDeleteClick;
  final List<String> path;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
        height: 50,
        child: Row(
          children: [
            Center(child: Text(postureLabel)),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit position',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditPosture(path: path, onEditClick: onEditClick);
                    }).then((exit) {
                  if (exit) return;
                });
              },
            ),
            Switch(
              value: isSwitched,
              onChanged: enabled ? onChanged : null,
              activeColor: enabled
                  ? theme.toggleableActiveColor
                  : theme.toggleButtonsTheme.disabledColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete position',
              onPressed: onDeleteClick,
            )
          ],
        ));
  }
}
