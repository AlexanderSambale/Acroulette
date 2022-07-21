import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vosk_flutter_plugin/vosk_flutter_plugin.dart';

part 'voice_recognition_event.dart';
part 'voice_recognition_state.dart';

class VoiceRecognitionBloc
    extends Bloc<VoiceRecognitionEvent, VoiceRecognitionState> {
  VoiceRecognitionBloc() : super(VoiceRecognitionInitial()) {
    on<VoiceRecognitionStart>((event, emit) {
      // TODO: implement event handler
    });
    on<VoiceRecognitionStop>((event, emit) {
      // TODO: implement event handler
    });
  }
}
