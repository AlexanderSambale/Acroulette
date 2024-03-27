part of 'position_administration_bloc.dart';

abstract class BasePositionAdministrationState extends Equatable {
  const BasePositionAdministrationState(this.trees);
  final List<Node> trees;

  @override
  List<Object> get props => [];
}

class PositionAdministrationInitialState
    extends BasePositionAdministrationState {
  const PositionAdministrationInitialState(super.trees);
}

class PositionAdministrationState extends BasePositionAdministrationState {
  const PositionAdministrationState(super.trees);
}
