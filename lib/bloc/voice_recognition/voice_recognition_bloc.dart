import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:equatable/equatable.dart';
import 'package:vosk_flutter_plugin/vosk_flutter_plugin.dart';

part 'voice_recognition_event.dart';
part 'voice_recognition_state.dart';

class VoiceRecognitionBloc
    extends Bloc<VoiceRecognitionEvent, VoiceRecognitionState> {
  VoiceRecognitionBloc() : super(VoiceRecognitionState.initial()) {
    Future<void> initModel() async {
      ByteData modelZip = await rootBundle
          .load('assets/models/vosk-model-small-en-us-0.15.zip');
      await VoskFlutterPlugin.initModel(modelZip);
    }

    on<VoiceRecognitionStart>((event, emit) async {
      await initModel();
      await VoskFlutterPlugin.start();
      VoskFlutterPlugin.onResult().listen(event.onData);
      emit(state.copyWith(isRecognizing: true));
    });
    on<VoiceRecognitionStop>((event, emit) {
      VoskFlutterPlugin.stop();
      emit(state.copyWith(isRecognizing: false));
    });
  }
}
