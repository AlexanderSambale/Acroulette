import 'package:acroulette/widgets/dialogs/flow_dialog/show_delete_flow_dialog.dart';
import 'package:acroulette/widgets/dialogs/posture_dialog/show_delete_posture_dialog.dart';
import 'package:acroulette/widgets/dialogs/posture_dialog/show_edit_posture_dialog.dart';
import 'package:acroulette/widgets/flows/flow_item.dart';
import 'package:acroulette/widgets/flows/flow_position_item.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:flutter/material.dart';

class FlowView extends StatelessWidget {
  const FlowView(
      {super.key,
      required this.flow,
      required this.toggleExpand,
      required this.onSavePostureClick,
      required this.onEditClick,
      required this.onEditFlowClick,
      required this.deletePosture,
      required this.deleteFlow,
      this.validator});

  final FlowNode flow;
  final void Function(FlowNode) toggleExpand;
  final void Function(FlowNode flowNode, String? label) onSavePostureClick;
  final void Function(FlowNode, int, String?) onEditClick;
  final void Function(FlowNode, String?) onEditFlowClick;
  final void Function(FlowNode, int) deletePosture;
  final void Function(FlowNode) deleteFlow;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Theme(
      data: theme,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.only(),
        title: FlowItem(
          flowLabel: flow.name,
          onEditClick: (flowName) => onEditFlowClick(flow, flowName),
          onSavePostureClick: (position) => onSavePostureClick(flow, position),
          showDeleteFlowDialog: (BuildContext context) {
            showDeleteFlowDialog(context, flow, () => deleteFlow(flow));
          },
          validator: validator,
        ),
        onExpansionChanged: (value) => toggleExpand(flow),
        initiallyExpanded: flow.isExpanded,
        controlAffinity: ListTileControlAffinity.leading,
        children: flow.positions
            .asMap()
            .map(
              (int index, String position) => MapEntry(
                index,
                Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: FlowPositionItem(
                    positionLabel: position,
                    showEditPositionDialog: (context) => showEditPositionDialog(
                      context,
                      [flow.name, position],
                      (positionLabel) => onEditClick(
                        flow,
                        index,
                        positionLabel,
                      ),
                    ),
                    showDeletePositionDialog: (context) =>
                        showDeletePositionDialog(
                      context,
                      [flow.name, position],
                      () => deletePosture(
                        flow,
                        index,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}
