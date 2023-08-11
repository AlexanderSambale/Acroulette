import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:acroulette/bloc/transition/transition_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransitionBloc', () {
    late TransitionBloc transitionBloc;

    setUp(() {
      transitionBloc = TransitionBloc((status) => {}, Random());
    });

    test('initial state index is -1', () {
      expect(transitionBloc.state.index, -1);
    });

    test('initial state figure is []', () {
      expect(transitionBloc.state.figures, []);
    });

    group('getRandomFigure', () {
      test(
          'can have the same figure twice in a row if sameAllowed is set to true',
          () {
        transitionBloc = TransitionBloc((status) => {}, Random(2));
        String figure1 =
            transitionBloc.getRandomFigure(['1', '2'], sameAllowed: true);
        String figure2 =
            transitionBloc.getRandomFigure(['1', '2'], sameAllowed: true);
        expect(figure1, figure2);
      });

      test(
          'cannot have the same figure twice in a row if sameAllowed is set to false',
          () {
        transitionBloc = TransitionBloc((status) => {}, Random(2));
        String figure1 = transitionBloc.getRandomFigure(['1', '2']);
        // same situation as at the start of the test
        // 'can have the same figure twice in a row if sameAllowed is set to true',
        // so getRandomFigure will generate a '2' and has to rerun internally
        // to finally get a '1'
        String figure2 =
            transitionBloc.getRandomFigure(['1', '2'], lastFigure: figure1);
        expect(figure1, isNot(figure2));
      });
    });
    blocTest<TransitionBloc, TransitionState>(
      'current figure',
      build: () => transitionBloc,
      seed: () =>
          const TransitionState(['1', '2'], 1, TransitionStatus.created),
      verify: (bloc) => expect(bloc.currentFigure(), '2'),
    );
    blocTest<TransitionBloc, TransitionState>(
      'next figure',
      build: () => transitionBloc,
      seed: () =>
          const TransitionState(['1', '2'], 0, TransitionStatus.created),
      verify: (bloc) => expect(bloc.nextFigure(), '2'),
    );
    blocTest<TransitionBloc, TransitionState>(
      'no next figure',
      build: () => transitionBloc,
      seed: () =>
          const TransitionState(['1', '2'], 1, TransitionStatus.created),
      verify: (bloc) => expect(bloc.nextFigure(), ''),
    );
    blocTest<TransitionBloc, TransitionState>(
      'previous figure',
      build: () => transitionBloc,
      seed: () =>
          const TransitionState(['1', '2'], 1, TransitionStatus.created),
      verify: (bloc) => expect(bloc.previousFigure(), '1'),
    );
    blocTest<TransitionBloc, TransitionState>(
      'no previous figure',
      build: () => transitionBloc,
      seed: () =>
          const TransitionState(['1', '2'], 0, TransitionStatus.created),
      verify: (bloc) => expect(bloc.previousFigure(), ''),
    );

    blocTest<TransitionBloc, TransitionState>(
      'InitFlowTransitionEvent',
      build: () => transitionBloc,
      act: (bloc) => bloc.add(InitFlowTransitionEvent(['1', '2'], true)),
      expect: () => [
        isA<TransitionState>()
            .having((bloc) => bloc.index, 'index', 0)
            .having((bloc) => bloc.status, 'TransitionStatus',
                TransitionStatus.changingStateProps)
            .having((bloc) => bloc.figures, 'figures', ['1', '2']),
        isA<TransitionState>()
            .having((bloc) => bloc.index, 'index', 0)
            .having((bloc) => bloc.status, 'TransitionStatus',
                TransitionStatus.current)
            .having((bloc) => bloc.figures, 'figures', ['1', '2']),
      ],
      verify: (bloc) => expect(bloc.currentFigure(), '1'),
    );

    blocTest<TransitionBloc, TransitionState>(
      'NewTransitionEvent leads to status created and index 0',
      build: () => TransitionBloc((status) => {}, Random(1)),
      act: (bloc) => bloc.add(NewTransitionEvent(['1', '2'])),
      expect: () => [
        isA<TransitionState>()
            .having((bloc) => bloc.index, 'index', 0)
            .having((bloc) => bloc.status, 'TransitionStatus',
                TransitionStatus.changingStateProps)
            .having((bloc) => bloc.figures, 'figures', ['1']),
        isA<TransitionState>()
            .having((bloc) => bloc.index, 'index', 0)
            .having((bloc) => bloc.status, 'TransitionStatus',
                TransitionStatus.created)
            .having((bloc) => bloc.figures, 'figures', ['1']),
      ],
      verify: (bloc) => expect(bloc.currentFigure(), '1'),
    );

    blocTest<TransitionBloc, TransitionState>(
      'NewTransitionEvent leads to status created and index 2',
      build: () => TransitionBloc((status) => {}, Random(1)),
      seed: () =>
          const TransitionState(['1', '2'], 0, TransitionStatus.previous),
      act: (bloc) => bloc.add(NewTransitionEvent(['1', '2'])),
      expect: () => [
        isA<TransitionState>()
            .having((bloc) => bloc.index, 'index', 2)
            .having((bloc) => bloc.status, 'TransitionStatus',
                TransitionStatus.changingStateProps)
            .having((bloc) => bloc.figures, 'figures', ['1', '2', '1']),
        isA<TransitionState>()
            .having((bloc) => bloc.index, 'index', 2)
            .having((bloc) => bloc.status, 'TransitionStatus',
                TransitionStatus.created)
            .having((bloc) => bloc.figures, 'figures', ['1', '2', '1']),
      ],
      verify: (bloc) => expect(bloc.currentFigure(), '1'),
    );

    blocTest<TransitionBloc, TransitionState>(
      'NextTransitionEvent leads to status next and index 1',
      build: () => transitionBloc,
      seed: () =>
          const TransitionState(['1', '2'], 0, TransitionStatus.previous),
      act: (bloc) => bloc.add(NextTransitionEvent()),
      expect: () => [
        isA<TransitionState>()
            .having((bloc) => bloc.index, 'index', 1)
            .having((bloc) => bloc.status, 'TransitionStatus',
                TransitionStatus.changingStateProps)
            .having((bloc) => bloc.figures, 'figures', ['1', '2']),
        isA<TransitionState>()
            .having((bloc) => bloc.index, 'index', 1)
            .having((bloc) => bloc.status, 'TransitionStatus',
                TransitionStatus.next)
            .having((bloc) => bloc.figures, 'figures', ['1', '2']),
      ],
      verify: (bloc) => expect(bloc.currentFigure(), '2'),
    );

    blocTest<TransitionBloc, TransitionState>(
      'NextTransitionEvent leads to status noMove and index 1',
      build: () => transitionBloc,
      seed: () =>
          const TransitionState(['1', '2'], 1, TransitionStatus.previous),
      act: (bloc) => bloc.add(NextTransitionEvent()),
      expect: () => [
        isA<TransitionState>()
            .having((bloc) => bloc.index, 'index', 1)
            .having((bloc) => bloc.status, 'TransitionStatus',
                TransitionStatus.noMove)
            .having((bloc) => bloc.figures, 'figures', ['1', '2']),
      ],
      verify: (bloc) => expect(bloc.currentFigure(), '2'),
    );

    blocTest<TransitionBloc, TransitionState>(
      'PreviousTransitionEvent leads to status noMove and index 0',
      build: () => transitionBloc,
      seed: () =>
          const TransitionState(['1', '2'], 1, TransitionStatus.previous),
      act: (bloc) => bloc.add(PreviousTransitionEvent()),
      expect: () => [
        isA<TransitionState>()
            .having((bloc) => bloc.index, 'index', 0)
            .having((bloc) => bloc.status, 'TransitionStatus',
                TransitionStatus.changingStateProps)
            .having((bloc) => bloc.figures, 'figures', ['1', '2']),
        isA<TransitionState>()
            .having((bloc) => bloc.index, 'index', 0)
            .having((bloc) => bloc.status, 'TransitionStatus',
                TransitionStatus.previous)
            .having((bloc) => bloc.figures, 'figures', ['1', '2']),
      ],
      verify: (bloc) => expect(bloc.currentFigure(), '1'),
    );

    blocTest<TransitionBloc, TransitionState>(
      'PreviousTransitionEvent leads to status noMove and index 2',
      build: () => transitionBloc,
      seed: () =>
          const TransitionState(['1', '2'], 0, TransitionStatus.previous),
      act: (bloc) => bloc.add(PreviousTransitionEvent()),
      expect: () => [
        isA<TransitionState>()
            .having((bloc) => bloc.index, 'index', 0)
            .having((bloc) => bloc.status, 'TransitionStatus',
                TransitionStatus.noMove)
            .having((bloc) => bloc.figures, 'figures', ['1', '2']),
      ],
      verify: (bloc) => expect(bloc.currentFigure(), '1'),
    );

    blocTest<TransitionBloc, TransitionState>(
      'CurrentTransitionEvent leads to status current and index 1',
      build: () => transitionBloc,
      seed: () =>
          const TransitionState(['1', '2'], 1, TransitionStatus.previous),
      act: (bloc) => bloc.add(CurrentTransitionEvent()),
      expect: () => [
        isA<TransitionState>()
            .having((bloc) => bloc.index, 'index', 1)
            .having((bloc) => bloc.status, 'TransitionStatus',
                TransitionStatus.changingStateProps)
            .having((bloc) => bloc.figures, 'figures', ['1', '2']),
        isA<TransitionState>()
            .having((bloc) => bloc.index, 'index', 1)
            .having((bloc) => bloc.status, 'TransitionStatus',
                TransitionStatus.current)
            .having((bloc) => bloc.figures, 'figures', ['1', '2']),
      ],
      verify: (bloc) => expect(bloc.currentFigure(), '2'),
    );
  });
}
