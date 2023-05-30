import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'dart:math';

part 'transition_event.dart';
part 'transition_state.dart';

class TransitionBloc extends Bloc<TransitionEvent, TransitionState> {
  TransitionBloc(this.externalOnChange, this.rng)
      : super(const TransitionState.initial()) {
    on<NewTransitionEvent>((event, emit) {
      final newFigures = List<String>.empty(growable: true);
      newFigures.addAll(state.figures);
      int index = newFigures.length;
      newFigures.add(getRandomFigure(event.possibleFigures,
          sameAllowed: false,
          lastFigure: state.figures.isEmpty ? '' : state.figures.last));
      emit(TransitionState(
          newFigures, index, TransitionStatus.changingStateProps));
      emit(TransitionState(newFigures, state.index, TransitionStatus.created));
    });
    on<NextTransitionEvent>((event, emit) {
      if (state.index + 1 < state.figures.length) {
        emit(TransitionState(state.figures, state.index + 1,
            TransitionStatus.changingStateProps));
        emit(
            TransitionState(state.figures, state.index, TransitionStatus.next));
      } else {
        /// no next figure is available
        emit(TransitionState(
            state.figures, state.index, TransitionStatus.noMove));
      }
    });
    on<PreviousTransitionEvent>((event, emit) {
      if (state.index > 0) {
        emit(TransitionState(state.figures, state.index - 1,
            TransitionStatus.changingStateProps));
        emit(TransitionState(
            state.figures, state.index, TransitionStatus.previous));
      } else {
        /// no previous figure is available
        emit(TransitionState(
            state.figures, state.index, TransitionStatus.noMove));
      }
    });
    on<CurrentTransitionEvent>((event, emit) {
      emit(TransitionState(
          state.figures, state.index, TransitionStatus.changingStateProps));
      // just call out the name of the current figure
      emit(TransitionState(
          state.figures, state.index, TransitionStatus.current));
    });
    on<InitFlowTransitionEvent>((event, emit) {
      emit(TransitionState(
          event.figures.toList(), 0, TransitionStatus.changingStateProps));
      add(CurrentTransitionEvent());
    });

    on<InitAcrouletteTransitionEvent>((event, emit) {
      emit(TransitionState([getRandomFigure(event.possibleFigures)], 0,
          TransitionStatus.changingStateProps));
      add(CurrentTransitionEvent());
    });
  }

  @override
  void onChange(Change<TransitionState> change) {
    super.onChange(change);
    externalOnChange(change.nextState.status);
  }

  final void Function(TransitionStatus status) externalOnChange;
  final Random rng;

  String getRandomFigure(List<String> possibleFigures,
      {bool sameAllowed = false, String lastFigure = ''}) {
    final newFigureIndex = rng.nextInt(possibleFigures.length);
    final newFigure = possibleFigures[newFigureIndex];
    if (newFigure == lastFigure) {
      return getRandomFigure(possibleFigures,
          sameAllowed: sameAllowed, lastFigure: lastFigure);
    }
    return newFigure;
  }

  String currentFigure() {
    return state.figures[state.index];
  }

  String previousFigure() {
    int previousIndex = state.index - 1;
    if (previousIndex < 0) return '';
    return state.figures[previousIndex];
  }

  String nextFigure() {
    int nextIndex = state.index + 1;
    if (nextIndex >= state.figures.length) return '';
    return state.figures[nextIndex];
  }
}
