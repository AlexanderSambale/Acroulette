import 'package:acroulette/constants/model.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'washing_machine_event.dart';
part 'washing_machine_state.dart';

class WashingMachineBloc
    extends Bloc<WashingMachineEvent, WashingMachineState> {
  WashingMachineBloc(ObjectBox objectbox)
      : super(const WashingMachineInitial()) {
    machine = objectbox.getSettingsPairValueByKey(flowIndex);

    on<WashingMachineChange>((event, emit) {
      if (machine != event.machine) {
        objectbox.putSettingsPairValueByKey(flowIndex, event.machine);
        machine = event.machine;
        event.onWashingMachineChange();
      }
      emit(WashingMachine(event.machine));
    });
  }

  late String machine;
}
