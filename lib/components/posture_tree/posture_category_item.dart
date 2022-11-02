import 'package:acroulette/components/dialogs/category_dialog/create_category_dialog.dart';
import 'package:acroulette/components/dialogs/category_dialog/delete_category_dialog.dart';
import 'package:acroulette/components/dialogs/category_dialog/edit_category_dialog.dart';
import 'package:acroulette/components/dialogs/posture_dialog/create_posture_dialog.dart';
import 'package:acroulette/components/icons/icons.dart';
import 'package:acroulette/models/pair.dart';
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
    required this.listAllNodesRecursively,
    this.validator,
    this.enabled = true,
  });

  final bool isSwitched;
  final bool isExpanded;
  final bool enabled;
  final String categoryLabel;
  final void Function(bool) onChanged;
  final void Function(bool, String?) onSaveClick;
  final String? Function(bool, String?)? validator;
  final void Function(String?) onEditClick;
  final void Function() onDeleteClick;
  final void Function() toggleExpand;
  final List<Pair> Function() listAllNodesRecursively;
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
            Container(
              width: 10,
            ),
            categoryIcon,
            Container(
              width: 10,
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
                          onSaveClick: (posture) => onSaveClick(true, posture),
                          validator: (posture) {
                            if (validator == null) return null;
                            return validator!(true, posture);
                          });
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
                              onSaveClick(false, category),
                          validator: (category) {
                            if (validator == null) return null;
                            return validator!(false, category);
                          });
                    }).then((exit) {
                  if (exit) return;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit category name',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditCategory(
                          path: path,
                          onEditClick: onEditClick,
                          validator: (category) {
                            if (validator == null) return null;
                            return validator!(false, category);
                          });
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
              tooltip: 'Delete category',
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return DeleteCategory(
                        onDeleteClick: onDeleteClick,
                        path: path,
                        elementsToRemove: listAllNodesRecursively(),
                      );
                    }).then((exit) {
                  if (exit) return;
                });
              },
            )
          ],
        ));
  }
}
