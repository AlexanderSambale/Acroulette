import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/domain_layer/settings_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mode_event.dart';
part 'mode_state.dart';

class ModeBloc extends Bloc<ModeEvent, ModeState> {
  ModeBloc(SettingsRepository settingsRepository) : super(const ModeInitial()) {
    on<ModeChange>((event, emit) async {
      if (mode != event.mode) {
        await settingsRepository.putSettingsPairValueByKey(appMode, event.mode);
        mode = event.mode;
        event.onModeChange();
      }
      emit(Mode(event.mode));
    });
    mode = acroulette;
    settingsRepository
        .getSettingsPairValueByKey(appMode)
        .then((value) => mode = value);
  }

  late String mode;
}
