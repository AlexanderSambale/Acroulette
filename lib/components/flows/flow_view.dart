import 'package:acroulette/components/dialogs/flow_dialog/show_delete_flow_dialog.dart';
import 'package:acroulette/components/dialogs/posture_dialog/show_delete_posture_dialog.dart';
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
    return Card(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: flow.positions.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return FlowItem(
                  flowLabel: flow.name,
                  onEditClick: (flowName) => onEditFlowClick(flow, flowName),
                  onSavePostureClick: (position) =>
                      onSavePostureClick(flow, position),
                  toggleExpand: () => toggleExpand(flow),
                  isExpanded: flow.isExpanded,
                  showDeleteFlowDialog: (BuildContext context) {
                    showDeleteFlowDialog(context, flow, () => deleteFlow(flow));
                  },
                  validator: validator,
                );
              }
              if (flow.isExpanded) {
                String positionLabel = flow.positions.elementAt(index - 1);
                return Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: FlowPositionItem(
                    positionLabel: positionLabel,
                    showEditPositionDialog: (context) => showEditPositionDialog(
                        context,
                        [flow.name, positionLabel],
                        (positionLabel) =>
                            onEditClick(flow, index - 1, positionLabel)),
                    showDeletePositionDialog: (context) =>
                        showDeletePositionDialog(
                            context,
                            [flow.name, positionLabel],
                            () => deletePosture(flow, index - 1)),
                  ),
                );
              }
              return Container();
            }));
  }
}
