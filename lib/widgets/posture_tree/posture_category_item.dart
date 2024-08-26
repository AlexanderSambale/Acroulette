import 'package:acroulette/helper/widgets/action_pane.dart';
import 'package:acroulette/widgets/dialogs/category_dialog/create_category_dialog.dart';
import 'package:acroulette/widgets/dialogs/category_dialog/delete_category_dialog.dart';
import 'package:acroulette/widgets/dialogs/category_dialog/edit_category_dialog.dart';
import 'package:acroulette/widgets/dialogs/posture_dialog/create_posture_dialog.dart';
import 'package:acroulette/widgets/formWidgets/icon_button.dart';
import 'package:acroulette/widgets/icons/icons.dart';
import 'package:acroulette/models/pair.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PostureCategoryItem extends StatelessWidget {
  const PostureCategoryItem({
    super.key,
    required this.isSwitched,
    required this.onChanged,
    required this.onEditClick,
    required this.onDeleteClick,
    required this.onSaveClick,
    required this.categoryLabel,
    required this.path,
    required this.listAllNodesRecursively,
    this.validator,
    this.enabled = true,
  });

  final bool isSwitched;
  final bool enabled;
  final String categoryLabel;
  final void Function(bool) onChanged;
  final void Function(bool, String?) onSaveClick;
  final String? Function(bool, String?)? validator;
  final void Function(String?) onEditClick;
  final void Function() onDeleteClick;
  final List<Pair> Function() listAllNodesRecursively;
  final List<String> path;

  @override
  Widget build(BuildContext context) {
    const double size = 32;
    const double padding = 4;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        List<Widget> children = [
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
          createIconButton(
            padding: padding,
            context: context,
            size: size,
            icon: const Icon(Icons.add_box),
            tooltip: 'Add Category',
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CreateCategory(
                        path: path,
                        onSaveClick: (category) => onSaveClick(false, category),
                        validator: (category) {
                          if (validator == null) return null;
                          return validator!(false, category);
                        });
                  }).then((exit) {
                if (exit) return;
              });
            },
          ),
          createIconButton(
            padding: padding,
            context: context,
            size: size,
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
        ];
        return SizedBox(
          height: size,
          child: ClipRRect(
            child: Slidable(
              key: Key(categoryLabel),
              startActionPane: ActionPane(
                extentRatio: calculateExtentRatio(
                  size: size,
                  padding: padding,
                  maxWidth: constraints.maxWidth,
                  numberOfWidgets: 3,
                ),
                motion: const ScrollMotion(),
                children: children,
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
                  ),
                ],
              ),
              child: Row(
                children: [
                  categoryIcon,
                  Container(
                    width: 8,
                  ),
                  Center(child: Text(categoryLabel)),
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
