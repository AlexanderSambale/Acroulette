import 'package:acroulette/widgets/dialogs/posture_dialog/delete_posture_dialog.dart';
import 'package:flutter/material.dart';

dynamic showDeletePositionDialog(
    BuildContext context, List<String> path, void Function() onDeleteClick) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeletePosture(path: path, onDeleteClick: onDeleteClick);
      }).then((exit) {
    if (exit) return;
  });
}
