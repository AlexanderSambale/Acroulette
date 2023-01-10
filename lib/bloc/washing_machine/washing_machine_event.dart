part of 'washing_machine_bloc.dart';

abstract class WashingMachineEvent {
  const WashingMachineEvent();
}

class WashingMachineChange extends WashingMachineEvent {
  final String machine;
  final void Function() onWashingMachineChange;
  const WashingMachineChange(this.machine, this.onWashingMachineChange);
}
