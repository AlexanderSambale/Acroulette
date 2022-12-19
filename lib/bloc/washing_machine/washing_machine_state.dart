part of 'washing_machine_bloc.dart';

abstract class WashingMachineState extends Equatable {
  const WashingMachineState();

  @override
  List<Object> get props => [];
}

class WashingMachineInitial extends WashingMachineState {
  const WashingMachineInitial();
}

class WashingMachine extends WashingMachineState {
  final String machine;
  const WashingMachine(this.machine);
}
