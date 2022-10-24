import 'package:flutter/material.dart';

class PostureListItem extends StatelessWidget {
  const PostureListItem(
      {super.key,
      required this.isSwitched,
      required this.postureLabel,
      required this.onChanged,
      required this.onEditClick,
      required this.onDeleteClick,
      this.enabled = true});

  final bool isSwitched;
  final bool enabled;
  final String postureLabel;
  final void Function(bool) onChanged;
  final void Function(bool, String?) onEditClick;
  final void Function() onDeleteClick;

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
              onPressed: () => onEditClick(false, postureLabel),
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
