part of 'washing_machine_bloc.dart';

abstract class WashingMachineEvent extends Equatable {
  const WashingMachineEvent();

  @override
  List<Object> get props => [];
}

class WashingMachineChange extends WashingMachineEvent {
  final String machine;
  final void Function() onWashingMachineChange;
  const WashingMachineChange(this.machine, this.onWashingMachineChange);
}
