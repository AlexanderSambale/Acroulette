part of 'flow_administration_bloc.dart';

abstract class FlowAdministrationEvent {
  const FlowAdministrationEvent();
}

// nodes and acro nodes change
class FlowDBStartChangeEvent extends FlowAdministrationEvent {}

// no sync with db is pending
class FlowDBIsIdleEvent extends FlowAdministrationEvent {}
