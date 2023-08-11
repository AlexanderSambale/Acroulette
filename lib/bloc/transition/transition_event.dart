part of 'transition_bloc.dart';

abstract class TransitionEvent {}

/// Go to the next figure in a list
class NextTransitionEvent extends TransitionEvent {}

/// Go to the previous figure
class PreviousTransitionEvent extends TransitionEvent {}

/// Tell the current figure
class CurrentTransitionEvent extends TransitionEvent {}

/// Triggers adding a new figure to the transitions list
class NewTransitionEvent extends TransitionEvent {
  late List<String> possibleFigures;
  NewTransitionEvent(this.possibleFigures);
}

class InitFlowTransitionEvent extends TransitionEvent {
  late List<String> figures;
  late bool loop;
  InitFlowTransitionEvent(this.figures, this.loop);
}

class InitAcrouletteTransitionEvent extends TransitionEvent {
  late List<String> possibleFigures;
  late bool loop;
  InitAcrouletteTransitionEvent(this.possibleFigures, this.loop);
}
