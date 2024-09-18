part of 'acroulette_bloc.dart';

@immutable
abstract class BaseAcrouletteState extends Equatable {
  const BaseAcrouletteState({required this.settings});

  final AcrouletteSettings settings;

  @override
  List<Object> get props => [settings];
}

class AcrouletteInitialState extends BaseAcrouletteState {
  const AcrouletteInitialState({
    required super.settings,
  });
}

class AcrouletteInitModel extends BaseAcrouletteState {
  const AcrouletteInitModel({
    required super.settings,
  });
}

class AcrouletteModelInitiatedState extends BaseAcrouletteState {
  const AcrouletteModelInitiatedState({
    required super.settings,
  });
}

class AcrouletteStopState extends BaseAcrouletteState {
  const AcrouletteStopState({
    required super.settings,
  });
}

class AcrouletteCommandRecognizedState extends BaseAcrouletteState {
  final String currentFigure;
  final String nextFigure;
  final String previousFigure;
  const AcrouletteCommandRecognizedState({
    required this.currentFigure,
    required super.settings,
    this.nextFigure = '',
    this.previousFigure = '',
  });

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => props.hashCode;

  @override
  List<Object> get props => [
        settings,
        currentFigure,
        nextFigure,
        previousFigure,
      ];
}

class AcrouletteFlowState extends BaseAcrouletteState {
  final String flowName;
  const AcrouletteFlowState({
    required super.settings,
    required this.flowName,
  });

  @override
  List<Object> get props => [settings, flowName];
}
