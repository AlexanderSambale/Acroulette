import 'package:acroulette/widgets/dialogs/flow_dialog/edit_flow_dialog.dart';
import 'package:flutter/material.dart';

showEditFlowDialog(BuildContext context, String flowName,
    void Function(String?) onEditClick, String? Function(String?)? validator) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditFlow(
            flowName: flowName, onEditClick: onEditClick, validator: validator);
      }).then((exit) {
    if (exit) return;
  });
}
