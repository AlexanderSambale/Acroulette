part of 'flow_administration_bloc.dart';

abstract class BaseFlowAdministrationState extends Equatable {
  const BaseFlowAdministrationState();

  @override
  List<Object?> get props => [];
}

class FlowAdministrationInitialState extends BaseFlowAdministrationState {
  const FlowAdministrationInitialState() : super();
}

class FlowAdministrationState extends BaseFlowAdministrationState {
  const FlowAdministrationState() : super();
}
