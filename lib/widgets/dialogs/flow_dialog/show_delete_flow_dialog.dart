import 'package:acroulette/widgets/dialogs/flow_dialog/delete_flow_dialog.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:flutter/material.dart';

showDeleteFlowDialog(
    BuildContext context, FlowNode flow, void Function() onDeleteClick) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DeleteFlow(
          onDeleteClick: onDeleteClick,
          flowLabel: flow.name,
          elementsToRemove: flow.positions,
        );
      }).then((exit) {
    if (exit) return;
  });
}
