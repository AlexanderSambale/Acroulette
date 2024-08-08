import 'package:acroulette/constants/model.dart';
import 'package:acroulette/domain_layer/settings_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'washing_machine_event.dart';
part 'washing_machine_state.dart';

class WashingMachineBloc
    extends Bloc<WashingMachineEvent, WashingMachineState> {
  WashingMachineBloc(SettingsRepository settingsRepository)
      : super(const WashingMachineInitial()) {
    on<WashingMachineChange>((event, emit) {
      if (machine != event.machine) {
        settingsRepository.putSettingsPairValueByKey(flowIndex, event.machine);
        machine = event.machine;
        event.onWashingMachineChange();
      }
      emit(WashingMachine(event.machine));
    });
    machine = '';
    settingsRepository
        .getSettingsPairValueByKey(flowIndex)
        .then((value) => machine = value);
  }

  late String machine;
}
