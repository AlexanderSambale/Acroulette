import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:acroulette/bloc/transition/transition_bloc.dart';

void main() {
  group('TransitionBloc', () {
    late TransitionBloc transitionBloc;

    setUp(() {
      transitionBloc = TransitionBloc();
    });

    test('initial state index is -1', () {
      expect(transitionBloc.state.index, -1);
    });

    test('initial state figure is []', () {
      expect(transitionBloc.state.figures, []);
    });
  });
}
