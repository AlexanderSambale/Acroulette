part of 'position_administration_bloc.dart';

abstract class PositionAdministrationEvent {
  const PositionAdministrationEvent();
}

// nodes and acro nodes change
class PositionsBDStartChangeEvent extends PositionAdministrationEvent {}

// no sync with db is pending
class PositionsDBIsIdleEvent extends PositionAdministrationEvent {
  final List<Node> trees;
  PositionsDBIsIdleEvent(this.trees);
}
