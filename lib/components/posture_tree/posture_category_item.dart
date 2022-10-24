import 'package:acroulette/components/dialogs/category_dialog/create_dategory_dialog.dart';
import 'package:acroulette/components/dialogs/posture_dialog/create_posture_dialog.dart';
import 'package:flutter/material.dart';

class PostureCategoryItem extends StatelessWidget {
  const PostureCategoryItem({
    super.key,
    required this.isSwitched,
    required this.isExpanded,
    required this.onChanged,
    required this.onEditClick,
    required this.onDeleteClick,
    required this.onSaveClick,
    required this.toggleExpand,
    required this.categoryLabel,
    required this.path,
    this.enabled = true,
  });

  final bool isSwitched;
  final bool isExpanded;
  final bool enabled;
  final String categoryLabel;
  final void Function(bool) onChanged;
  final void Function(bool, String?) onSaveClick;
  final void Function(bool, String?) onEditClick;
  final void Function() onDeleteClick;
  final void Function() toggleExpand;
  final List<String> path;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
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
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CreatePosture(
                          path: path,
                          onSaveClick: (posture) => onSaveClick(true, posture));
                    }).then((exit) {
                  if (exit) return;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_box),
              tooltip: 'Add Category',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CreateCategory(
                          path: path,
                          onSaveClick: (category) =>
                              onSaveClick(false, category));
                    }).then((exit) {
                  if (exit) return;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit position',
              onPressed: () => onEditClick(true, categoryLabel),
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
