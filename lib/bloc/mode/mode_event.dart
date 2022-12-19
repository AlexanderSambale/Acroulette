part of 'mode_bloc.dart';

abstract class ModeEvent extends Equatable {
  const ModeEvent();

  @override
  List<Object> get props => [];
}

class ModeChange extends ModeEvent {
  final String mode;
  final void Function() onModeChange;
  const ModeChange(this.mode, this.onModeChange);
}
