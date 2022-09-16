part of 'position_administration_bloc.dart';

abstract class BasePositionAdministrationState extends Equatable {
  BasePositionAdministrationState();
  BasePositionAdministrationState.withTree(this.tree);
  late Node tree;

  @override
  List<Object> get props => [];
}

class PositionAdministrationInitialState
    extends BasePositionAdministrationState {
  PositionAdministrationInitialState() : super();
  PositionAdministrationInitialState.withTree(this.tree);

  @override
  late Node tree;
}

class PositionAdministrationState extends BasePositionAdministrationState {
  PositionAdministrationState() : super();
}
