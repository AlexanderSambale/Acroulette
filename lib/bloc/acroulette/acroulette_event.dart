part of 'acroulette_bloc.dart';

abstract class AcrouletteEvent {}

class AcrouletteStart extends AcrouletteEvent {}

class AcrouletteInitModelEvent extends AcrouletteEvent {}

class AcrouletteStartVoiceRecognitionEvent extends AcrouletteEvent {}

class AcrouletteCommandRecognizedEvent extends AcrouletteEvent {
  final String currentFigure;
  AcrouletteCommandRecognizedEvent(this.currentFigure);
}

class AcrouletteStop extends AcrouletteEvent {}

class AcrouletteTransition extends AcrouletteEvent {
  final String transition;
  AcrouletteTransition(this.transition);
}

class AcrouletteRecognizeCommand extends AcrouletteEvent {
  final String command;
  AcrouletteRecognizeCommand(this.command);
}
