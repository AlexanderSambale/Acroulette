import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:vosk_flutter_plugin/vosk_flutter_plugin.dart';

part 'voice_recognition_event.dart';
part 'voice_recognition_state.dart';

class VoiceRecognitionBloc
    extends Bloc<VoiceRecognitionEvent, VoiceRecognitionState> {
  VoiceRecognitionBloc() : super(VoiceRecognitionState.initial()) {
    on<VoiceRecognitionStart>((event, emit) {
      VoskFlutterPlugin.start();
      state.isRecognizing = true;
      emit(state);
    });
    on<VoiceRecognitionStop>((event, emit) {
      VoskFlutterPlugin.stop();
      state.isRecognizing = false;
      emit(state);
    });
  }
}
