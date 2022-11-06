part of 'transition_bloc.dart';

abstract class TransitionEvent {}

/// Go to the next figure in a list
class NextTransitionEvent extends TransitionEvent {}

/// Go to the previous figure
class PreviousTransitionEvent extends TransitionEvent {}

/// Tell the current figure
class CurrentTransitionEvent extends TransitionEvent {}

/// Triggers adding a new figure to the transitions list
class NewTransitionEvent extends TransitionEvent {}

class InitFlowTransitionEvent extends TransitionEvent {
  late List<String> figures;
  InitFlowTransitionEvent(this.figures);
}

class InitAcrouletteTransitionEvent extends TransitionEvent {
  InitAcrouletteTransitionEvent();
}
