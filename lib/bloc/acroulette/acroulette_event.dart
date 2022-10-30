part of 'acroulette_bloc.dart';

abstract class AcrouletteEvent {}

class AcrouletteStart extends AcrouletteEvent {}

class AcrouletteInitModelEvent extends AcrouletteEvent {}

class AcrouletteStartVoiceRecognitionEvent extends AcrouletteEvent {}

class AcrouletteCommandRecognizedEvent extends AcrouletteEvent {
  final String currentFigure;
  final String nextFigure;
  final String previousFigure;
  AcrouletteCommandRecognizedEvent(this.currentFigure,
      {this.nextFigure = '', this.previousFigure = ''});
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
