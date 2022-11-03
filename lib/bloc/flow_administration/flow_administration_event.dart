part of 'flow_administration_bloc.dart';

abstract class FlowAdministrationEvent extends Equatable {
  const FlowAdministrationEvent();

  @override
  List<Object> get props => [];
}

// nodes and acro nodes change
class FlowBDStartChangeEvent extends FlowAdministrationEvent {}

// no sync with db is pending
class FlowDBIsIdleEvent extends FlowAdministrationEvent {}
