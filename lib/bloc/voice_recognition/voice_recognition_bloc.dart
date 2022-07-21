import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
