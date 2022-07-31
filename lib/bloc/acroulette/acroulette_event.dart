part of 'acroulette_bloc.dart';

abstract class AcrouletteEvent {}

class AcrouletteStart extends AcrouletteEvent {}

class AcrouletteStop extends AcrouletteEvent {}

class AcrouletteRecognizeCommand extends AcrouletteEvent {
  final String command;
  AcrouletteRecognizeCommand(this.command);
}
