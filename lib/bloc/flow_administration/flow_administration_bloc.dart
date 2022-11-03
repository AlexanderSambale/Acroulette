import 'package:acroulette/constants/validator.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'flow_administration_event.dart';
part 'flow_administration_state.dart';

class FlowAdministrationBloc
    extends Bloc<FlowAdministrationEvent, BaseFlowAdministrationState> {
  FlowAdministrationBloc(this.objectbox)
      : super(const FlowAdministrationInitialState()) {
    on<FlowBDStartChangeEvent>((event, emit) {
      emit(const FlowAdministrationState());
    });
    on<FlowDBIsIdleEvent>((event, emit) {
      emit(const FlowAdministrationInitialState());
    });
  }

  late ObjectBox objectbox;

  void toggleExpand(FlowNode flow) {
    add(FlowBDStartChangeEvent());
    flow.isExpanded = !flow.isExpanded;
    objectbox.putFlowNode(flow);
    add(FlowDBIsIdleEvent());
  }

  void createPosture(FlowNode flowNode, String posture) {
    add(FlowBDStartChangeEvent());
    flowNode.positions.add(posture);
    objectbox.putFlowNode(flowNode);
    add(FlowDBIsIdleEvent());
  }

  void editPosture(FlowNode flowNode, int index, String label) {
    add(FlowBDStartChangeEvent());
    flowNode.positions[index] = label;
    objectbox.putFlowNode(flowNode);
    add(FlowDBIsIdleEvent());
  }

  void deletePosture(FlowNode flowNode, int index) {
    add(FlowBDStartChangeEvent());
    flowNode.positions.removeAt(index);
    objectbox.putFlowNode(flowNode);
    add(FlowDBIsIdleEvent());
  }

  void deleteFlow(FlowNode flowNode) {
    add(FlowBDStartChangeEvent());
    objectbox.removeFlowNode(flowNode);
    add(FlowDBIsIdleEvent());
  }

  void createFlow(String flow) {
    add(FlowBDStartChangeEvent());
    objectbox.putFlowNode(FlowNode(flow, []));
    add(FlowDBIsIdleEvent());
  }

  void onSavePostureClick(FlowNode flowNode, String? label) {
    if (label == null) return;
    createPosture(flowNode, label);
  }

  void onSaveFlowClick(String? label) {
    if (label == null) return;
    createFlow(label);
  }

  void onEditClick(FlowNode flowNode, int index, String? label) {
    if (label == null) return;
    editPosture(flowNode, index, label);
  }

  String? validatorFlow(String label) {
    if (objectbox.flowExists(label)) {
      return existsText('Flow', label);
    }
    return null;
  }
}
