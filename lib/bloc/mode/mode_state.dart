part of 'mode_bloc.dart';

abstract class ModeState extends Equatable {
  const ModeState();

  @override
  List<Object> get props => [];
}

class ModeInitial extends ModeState {
  const ModeInitial();
}

class Mode extends ModeState {
  final String mode;
  const Mode(this.mode);
}
