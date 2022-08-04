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

class AcrouletteVoiceRecognitionStartedState extends BaseAcrouletteState {}

class AcrouletteStopState extends BaseAcrouletteState {}

class AcrouletteRecognizeCommandState extends BaseAcrouletteState {}
