import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'dart:math';

part 'transition_event.dart';
part 'transition_state.dart';

const figures = ["bird", "star", "bat", "triangle", "backbird", "reversebird"];

class TransitionBloc extends Bloc<TransitionEvent, TransitionState> {
  TransitionBloc() : super(const TransitionState.initial()) {
    on<NewTransitionEvent>((event, emit) {
      final figures = List<String>.empty(growable: true);
      figures.addAll(state.figures);
      figures.add(getRandomFigure());
      emit(TransitionState(figures, state.index + 1, TransitionStatus.create));
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
    on<SubscribeTransitionStreamEvent>((event, emit) {});
    on<UnSubscribeTransitionStreamEvent>((event, emit) {});
  }

  final rng = Random();

  String getRandomFigure() {
    final newFigureIndex = rng.nextInt(figures.length);
    return figures[newFigureIndex];
  }
}
