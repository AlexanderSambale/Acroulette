import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tts_event.dart';
part 'tts_state.dart';

class TtsBloc extends Bloc<TtsEvent, TtsState> {
  TtsBloc() : super(TtsInitial()) {
    on<TtsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
