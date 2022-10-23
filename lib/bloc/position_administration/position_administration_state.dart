part of 'position_administration_bloc.dart';

abstract class BasePositionAdministrationState extends Equatable {
  const BasePositionAdministrationState(this.tree);
  const BasePositionAdministrationState.withTree(this.tree);
  final Node tree;

  @override
  List<Object> get props => [];
}

class PositionAdministrationInitialState
    extends BasePositionAdministrationState {
  const PositionAdministrationInitialState(Node tree) : super(tree);
  const PositionAdministrationInitialState.withTree(Node tree)
      : super.withTree(tree);
}

class PositionAdministrationState extends BasePositionAdministrationState {
  const PositionAdministrationState(Node tree) : super(tree);
}
