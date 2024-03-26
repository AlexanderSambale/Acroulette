import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/db_controller.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mode_event.dart';
part 'mode_state.dart';

class ModeBloc extends Bloc<ModeEvent, ModeState> {
  ModeBloc(DBController dbController) : super(const ModeInitial()) {
    on<ModeChange>((event, emit) {
      if (mode != event.mode) {
        dbController.putSettingsPairValueByKey(appMode, event.mode);
        mode = event.mode;
        event.onModeChange();
      }
      emit(Mode(event.mode));
    });

    mode = dbController.getSettingsPairValueByKey(appMode);
  }

  late String mode;
}
