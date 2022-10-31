import 'package:acroulette/components/dialogs/flow_dialog/show_delete_flow_dialog.dart';
import 'package:acroulette/components/dialogs/posture_dialog/show_edit_posture_dialog.dart';
import 'package:acroulette/components/flows/flow_item.dart';
import 'package:acroulette/components/flows/flow_position_item.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:flutter/material.dart';

class FlowView extends StatelessWidget {
  const FlowView(
      {super.key,
      required this.flow,
      required this.toggleExpand,
      required this.onSaveClick,
      required this.onEditClick,
      required this.onDeleteClick});

  final FlowNode flow;
  final void Function(FlowNode) toggleExpand;
  final void Function(FlowNode, bool, String?) onSaveClick;
  final void Function(FlowNode, bool, String?) onEditClick;
  final void Function(FlowNode) onDeleteClick;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: flow.positions.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return FlowItem(
                  flowLabel: flow.name,
                  onEditClick: (String? value) =>
                      onEditClick(flow, false, value),
                  onSaveClick: (bool isPosture, String? value) =>
                      onSaveClick(flow, isPosture, value),
                  toggleExpand: () => toggleExpand(flow),
                  isExpanded: flow.isExpanded,
                  showDeleteFlowDialog: (BuildContext context) {
                    showDeleteFlowDialog(
                        context, flow, () => onDeleteClick(flow));
                  },
                );
              }
              if (flow.isExpanded) {
                return Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: FlowPositionItem(
                    positionLabel: flow.positions.elementAt(index - 1),
                    showEditPositionDialog: (context) => showEditPositionDialog(
                        context,
                        [flow.name],
                        (positionLabel) =>
                            onEditClick(flow, true, positionLabel)),
                    onDeleteClick: () => onDeleteClick(flow),
                  ),
                );
              }
              return Container();
            }));
  }
}
