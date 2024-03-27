part of 'transition_bloc.dart';

enum TransitionStatus {
  changingStateProps,
  created,
  initial,
  next,
  previous,
  noMove,
  current
}

@immutable
abstract class BaseTransitionState extends Equatable {
  final List<String> figures;
  final int index;
  final TransitionStatus status;

  const BaseTransitionState(this.figures, this.index, this.status);

  @override
  List<Object> get props => [figures, index, status];
}

/// If index is -1, we have an empty list of figures

class TransitionState extends BaseTransitionState {
  const TransitionState(super.figures, super.index, super.status);
  const TransitionState.initial()
      : super(const [], -1, TransitionStatus.initial);
}
