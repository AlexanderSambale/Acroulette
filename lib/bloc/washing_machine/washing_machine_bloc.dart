import 'package:acroulette/constants/model.dart';
import 'package:acroulette/db_controller.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'washing_machine_event.dart';
part 'washing_machine_state.dart';

class WashingMachineBloc
    extends Bloc<WashingMachineEvent, WashingMachineState> {
  WashingMachineBloc(DBController dbController)
      : super(const WashingMachineInitial()) {
    on<WashingMachineChange>((event, emit) {
      if (machine != event.machine) {
        dbController.putSettingsPairValueByKey(flowIndex, event.machine);
        machine = event.machine;
        event.onWashingMachineChange();
      }
      emit(WashingMachine(event.machine));
    });
    machine = '';
    dbController
        .getSettingsPairValueByKey(flowIndex)
        .then((value) => machine = value);
  }

  late String machine;
}
