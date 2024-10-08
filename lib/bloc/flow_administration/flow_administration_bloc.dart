import 'package:acroulette/constants/validator.dart';
import 'package:acroulette/domain_layer/flow_node_repository.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'flow_administration_event.dart';
part 'flow_administration_state.dart';

class FlowAdministrationBloc
    extends Bloc<FlowAdministrationEvent, BaseFlowAdministrationState> {
  FlowAdministrationBloc(this.flowNodeRepository)
      : super(const FlowAdministrationInitialState()) {
    on<FlowDBStartChangeEvent>((event, emit) {
      emit(const FlowAdministrationState());
    });
    on<FlowDBIsIdleEvent>((event, emit) {
      emit(const FlowAdministrationInitialState());
    });
  }

  late FlowNodeRepository flowNodeRepository;

  void toggleExpand(FlowNode flow) {
    add(FlowDBStartChangeEvent());
    flow.isExpanded = !flow.isExpanded;
    flowNodeRepository.editFlow(flow);
    add(FlowDBIsIdleEvent());
  }

  void createPosture(FlowNode flowNode, String posture) {
    add(FlowDBStartChangeEvent());
    flowNode.positions.add(posture);
    flowNodeRepository.editFlow(flowNode);
    add(FlowDBIsIdleEvent());
  }

  void editPosture(FlowNode flowNode, int index, String label) {
    add(FlowDBStartChangeEvent());
    flowNode.positions[index] = label;
    flowNodeRepository.editFlow(flowNode);
    add(FlowDBIsIdleEvent());
  }

  void editFlow(FlowNode flowNode, String label) {
    add(FlowDBStartChangeEvent());
    flowNode.name = label;
    flowNodeRepository.editFlow(flowNode);
    add(FlowDBIsIdleEvent());
  }

  void deletePosture(FlowNode flowNode, int index) {
    add(FlowDBStartChangeEvent());
    flowNode.positions.removeAt(index);
    flowNodeRepository.editFlow(flowNode);
    add(FlowDBIsIdleEvent());
  }

  void deleteFlow(FlowNode flowNode) {
    add(FlowDBStartChangeEvent());
    flowNodeRepository.removeFlowNode(flowNode);
    add(FlowDBIsIdleEvent());
  }

  void createFlow(String flow) {
    add(FlowDBStartChangeEvent());
    flowNodeRepository.createFlow(FlowNode(flow, []));
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

  String? validatorFlow(String? label) {
    if (label == null || label.isEmpty) return enterText;
    if (flowNodeRepository.flowExists(label)) {
      return existsText('Flow', label);
    }
    return null;
  }
}
