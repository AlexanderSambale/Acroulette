import 'package:flutter/material.dart';

class PostureCategoryItem extends StatelessWidget {
  const PostureCategoryItem(
      {super.key,
      required this.isSwitched,
      required this.isExpanded,
      required this.onChanged,
      required this.toggleExpand,
      required this.categoryLabel,
      this.enabled = true});

  final bool isSwitched;
  final bool isExpanded;
  final bool enabled;
  final String categoryLabel;
  final void Function(bool) onChanged;
  final void Function() toggleExpand;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
        height: 50,
        child: Row(
          children: [
            IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              tooltip: isExpanded ? 'collapse' : 'expand',
              onPressed: toggleExpand,
            ),
            Center(child: Text(categoryLabel)),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add_circle_rounded),
              tooltip: 'Add position',
              onPressed: () {},
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
              onPressed: () {},
            )
          ],
        ));
  }
}
