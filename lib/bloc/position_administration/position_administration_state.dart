part of 'position_administration_bloc.dart';

abstract class BasePositionAdministrationState extends Equatable {
  const BasePositionAdministrationState(this.tree);
  final Node tree;

  @override
  List<Object> get props => [];
}

class PositionAdministrationInitialState
    extends BasePositionAdministrationState {
  const PositionAdministrationInitialState(Node tree) : super(tree);
}

class PositionAdministrationState extends BasePositionAdministrationState {
  const PositionAdministrationState(Node tree) : super(tree);
}
