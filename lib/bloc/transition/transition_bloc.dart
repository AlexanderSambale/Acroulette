import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'dart:math';

part 'transition_event.dart';
part 'transition_state.dart';

const figures = [
  "bird",
  "star",
  "bat",
  "triangle",
  "backbird",
  "reversebird",
  "throne",
  "chair",
  "fallen leaf",
  "side star",
  "vishnus couch",
  "high flying whale"
];

class TransitionBloc extends Bloc<TransitionEvent, TransitionState> {
  TransitionBloc(this.externalOnChange)
      : super(const TransitionState.initial()) {
    on<NewTransitionEvent>((event, emit) {
      final newFigures = List<String>.empty(growable: true);
      newFigures.addAll(state.figures);
      newFigures.add(getRandomFigure());
      emit(TransitionState(
          newFigures, state.index + 1, TransitionStatus.create));
      emit(TransitionState(newFigures, state.index, TransitionStatus.created));
    });
    on<NextTransitionEvent>((event, emit) {
      if (state.index + 1 < state.figures.length) {
        emit(TransitionState(
            state.figures, state.index + 1, TransitionStatus.next));
      } else {
        /// no next figure is available
        emit(TransitionState(
            state.figures, state.index, TransitionStatus.nomove));
      }
    });
    on<PreviousTransitionEvent>((event, emit) {
      if (state.index > 0) {
        emit(TransitionState(
            state.figures, state.index - 1, TransitionStatus.previous));
      } else {
        /// no previous figure is available
        emit(TransitionState(
            state.figures, state.index, TransitionStatus.nomove));
      }
    });
    on<CurrentTransitionEvent>((event, emit) {
      // just call out the name of the current figure
      emit(TransitionState(
          state.figures, state.index, TransitionStatus.current));
    });
  }

  @override
  void onChange(Change<TransitionState> change) {
    super.onChange(change);
    externalOnChange(change.nextState.status);
  }

  final void Function(TransitionStatus status) externalOnChange;
  final rng = Random();

  String getRandomFigure() {
    final newFigureIndex = rng.nextInt(figures.length);
    return figures[newFigureIndex];
  }

  String currentFigure() {
    return state.figures[state.index];
  }
}
