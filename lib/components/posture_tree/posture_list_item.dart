import 'package:flutter/material.dart';

class PostureListItem extends StatelessWidget {
  const PostureListItem(
      {super.key,
      required this.isSwitched,
      required this.postureLabel,
      required this.onChanged,
      required this.delete,
      this.enabled = true});

  final bool isSwitched;
  final bool enabled;
  final String postureLabel;
  final void Function(bool) onChanged;
  final void Function() delete;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
        height: 50,
        child: Row(
          children: [
            Center(child: Text(postureLabel)),
            const Spacer(),
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
              onPressed: delete,
            )
          ],
        ));
  }
}
