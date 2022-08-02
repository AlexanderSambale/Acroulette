import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:acroulette/bloc/transition/transition_bloc.dart';

void main() {
  group('TransitionBloc', () {
    late TransitionBloc transitionBloc;

    setUp(() {
      transitionBloc = TransitionBloc(() => {});
    });

    test('initial state index is -1', () {
      expect(transitionBloc.state.index, -1);
    });

    test('initial state figure is []', () {
      expect(transitionBloc.state.figures, []);
    });

    blocTest<TransitionBloc, TransitionState>(
      'NewTransitionEvent leads to status create and index 0',
      build: () => transitionBloc,
      act: (bloc) => bloc.add(NewTransitionEvent()),
      expect: () => [
        isA<TransitionState>().having((bloc) => bloc.index, 'index', 0).having(
            (bloc) => bloc.status, 'TransitionStatus', TransitionStatus.create)
      ],
    );
  });
}
