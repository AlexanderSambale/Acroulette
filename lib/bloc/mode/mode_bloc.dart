import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mode_event.dart';
part 'mode_state.dart';

class ModeBloc extends Bloc<ModeEvent, ModeState> {
  ModeBloc(ObjectBox objectbox) : super(const ModeInitial()) {
    mode = objectbox.getSettingsPairValueByKey(appMode);

    on<ModeChange>((event, emit) {
      if (mode != event.mode) {
        objectbox.putSettingsPairValueByKey(appMode, event.mode);
        mode = event.mode;
        event.onModeChange();
      }
      emit(Mode(event.mode));
    });
  }

  late String mode;
}
