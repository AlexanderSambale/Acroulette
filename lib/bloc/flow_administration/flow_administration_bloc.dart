import 'package:acroulette/constants/validator.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/db_controller.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'flow_administration_event.dart';
part 'flow_administration_state.dart';

class FlowAdministrationBloc
    extends Bloc<FlowAdministrationEvent, BaseFlowAdministrationState> {
  FlowAdministrationBloc(this.dbController)
      : super(const FlowAdministrationInitialState()) {
    on<FlowDBStartChangeEvent>((event, emit) {
      emit(const FlowAdministrationState());
    });
    on<FlowDBIsIdleEvent>((event, emit) {
      emit(const FlowAdministrationInitialState());
    });
  }

  late DBController dbController;

  void toggleExpand(FlowNode flow) {
    add(FlowDBStartChangeEvent());
    flow.isExpanded = !flow.isExpanded;
    dbController.putFlowNode(flow);
    add(FlowDBIsIdleEvent());
  }

  void createPosture(FlowNode flowNode, String posture) {
    add(FlowDBStartChangeEvent());
    flowNode.positions.add(posture);
    dbController.putFlowNode(flowNode);
    add(FlowDBIsIdleEvent());
  }

  void editPosture(FlowNode flowNode, int index, String label) {
    add(FlowDBStartChangeEvent());
    flowNode.positions[index] = label;
    dbController.putFlowNode(flowNode);
    add(FlowDBIsIdleEvent());
  }

  void editFlow(FlowNode flowNode, String label) {
    add(FlowDBStartChangeEvent());
    flowNode.name = label;
    dbController.putFlowNode(flowNode);
    add(FlowDBIsIdleEvent());
  }

  void deletePosture(FlowNode flowNode, int index) {
    add(FlowDBStartChangeEvent());
    flowNode.positions.removeAt(index);
    dbController.putFlowNode(flowNode);
    add(FlowDBIsIdleEvent());
  }

  void deleteFlow(FlowNode flowNode) {
    add(FlowDBStartChangeEvent());
    dbController.removeFlowNode(flowNode);
    add(FlowDBIsIdleEvent());
  }

  void createFlow(String flow) {
    add(FlowDBStartChangeEvent());
    dbController.putFlowNode(FlowNode(flow, []));
    add(FlowDBIsIdleEvent());
  }

  void onSavePostureClick(FlowNode flowNode, String? label) {
    if (label == null || label.isEmpty) return;
    createPosture(flowNode, label);
  }

  void onSaveFlowClick(String? label) {
    if (label == null || label.isEmpty) return;
    createFlow(label);
  }

  void onEditClick(FlowNode flowNode, int index, String? label) {
    if (label == null || label.isEmpty) return;
    editPosture(flowNode, index, label);
  }

  void onEditFlowClick(FlowNode flowNode, String? label) {
    if (label == null || label.isEmpty) return;
    editFlow(flowNode, label);
  }

  Future<String?> validatorFlow(String? label) async {
    if (label == null || label.isEmpty) return enterText;
    if (await dbController.flowExists(label)) {
      return existsText('Flow', label);
    }
    return null;
  }
}
