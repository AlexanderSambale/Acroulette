import 'package:acroulette/widgets/dialogs/posture_dialog/edit_posture_dialog.dart';
import 'package:flutter/material.dart';

dynamic showEditPositionDialog(BuildContext context, List<String> path,
    void Function(String?) onEditClick) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPosture(path: path, onEditClick: onEditClick);
      }).then((exit) {
    if (exit) return;
  });
}
