part of 'acroulette_bloc.dart';

@immutable
abstract class BaseAcrouletteState extends Equatable {
  const BaseAcrouletteState();

  @override
  List<Object> get props => [];
}

class AcrouletteInitialState extends BaseAcrouletteState {}

class AcrouletteInitModel extends BaseAcrouletteState {}

class AcrouletteModelInitiatedState extends BaseAcrouletteState {}

class AcrouletteStopState extends BaseAcrouletteState {}

class AcrouletteCommandRecognizedState extends BaseAcrouletteState {
  final String currentFigure;
  final String nextFigure;
  final String previousFigure;
  final String mode;
  const AcrouletteCommandRecognizedState(this.currentFigure,
      {this.nextFigure = '', this.previousFigure = '', this.mode = acroulette});

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => props.hashCode;

  @override
  List<Object> get props => [currentFigure, nextFigure, previousFigure, mode];
}

class AcrouletteFlowState extends BaseAcrouletteState {
  final String flowName;
  const AcrouletteFlowState(this.flowName);

  @override
  List<Object> get props => [flowName];
}
