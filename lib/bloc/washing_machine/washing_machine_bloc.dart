import 'package:acroulette/constants/model.dart';
import 'package:acroulette/storage_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'washing_machine_event.dart';
part 'washing_machine_state.dart';

class WashingMachineBloc
    extends Bloc<WashingMachineEvent, WashingMachineState> {
  WashingMachineBloc(StorageProvider storageProvider)
      : super(const WashingMachineInitial()) {
    on<WashingMachineChange>((event, emit) {
      if (machine != event.machine) {
        storageProvider.putSettingsPairValueByKey(flowIndex, event.machine);
        machine = event.machine;
        event.onWashingMachineChange();
      }
      emit(WashingMachine(event.machine));
    });
    machine = '';
    storageProvider
        .getSettingsPairValueByKey(flowIndex)
        .then((value) => machine = value);
  }

  late String machine;
}
