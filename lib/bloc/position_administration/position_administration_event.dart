part of 'position_administration_bloc.dart';

abstract class PositionAdministrationEvent extends Equatable {
  const PositionAdministrationEvent();

  @override
  List<Object> get props => [];
}

// nodes and acro nodes change
class PositionsBDStartChangeEvent extends PositionAdministrationEvent {}

// no sync with db is pending
class PositionsDBIsIdleEvent extends PositionAdministrationEvent {}
