part of 'acroulette_bloc.dart';

@immutable
abstract class BaseAcrouletteState extends Equatable {
  const BaseAcrouletteState();

  @override
  List<Object> get props => [];
}

/// If index is -1, we have an empty list of figures

class AcrouletteState extends BaseAcrouletteState {
  const AcrouletteState() : super();
}
