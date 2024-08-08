import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/storage_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mode_event.dart';
part 'mode_state.dart';

class ModeBloc extends Bloc<ModeEvent, ModeState> {
  ModeBloc(StorageProvider storageProvider) : super(const ModeInitial()) {
    on<ModeChange>((event, emit) async {
      if (mode != event.mode) {
        await storageProvider.putSettingsPairValueByKey(appMode, event.mode);
        mode = event.mode;
        event.onModeChange();
      }
      emit(Mode(event.mode));
    });
    mode = acroulette;
    storageProvider
        .getSettingsPairValueByKey(appMode)
        .then((value) => mode = value);
  }

  late String mode;
}
