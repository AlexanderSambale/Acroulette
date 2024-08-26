import 'package:acroulette/widgets/dialogs/posture_dialog/edit_posture_dialog.dart';
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
    ThemeData theme = Theme.of(context);
    return Card(
      child: SizedBox(
        height: 50,
        child: Slidable(
          key: Key(postureLabel),
          startActionPane: const ActionPane(
            motion: ScrollMotion(),
            children: [],
          ),
          endActionPane: const ActionPane(
            motion: ScrollMotion(),
            children: [],
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
              IconButton(
                constraints: const BoxConstraints(minWidth: 32),
                padding: const EdgeInsets.all(0),
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
              SizedBox(
                  height: 24.0,
                  width: 32.0,
                  child: Switch(
                    value: isSwitched,
                    onChanged: enabled ? onChanged : null,
                    activeColor: enabled
                        ? theme.toggleButtonsTheme.color
                        : theme.toggleButtonsTheme.disabledColor,
                  )),
              IconButton(
                constraints: const BoxConstraints(minWidth: 32),
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.delete),
                tooltip: 'Delete position',
                onPressed: () => showDeletePositionDialog(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
