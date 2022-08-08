import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:equatable/equatable.dart';
import 'package:vosk_flutter_plugin/vosk_flutter_plugin.dart';

part 'voice_recognition_event.dart';
part 'voice_recognition_state.dart';

class VoiceRecognitionBloc
    extends Bloc<VoiceRecognitionEvent, VoiceRecognitionState> {
  final void Function() onInitiated;

  VoiceRecognitionBloc(this.onInitiated)
      : super(const VoiceRecognitionState.initial()) {
    initModel(onInitiated);

    on<VoiceRecognitionStart>((event, emit) async {
      await VoskFlutterPlugin.start();
      event.onRecognitionStarted();
      VoskFlutterPlugin.onResult().listen(event.onData);
      emit(state.copyWith(isRecognizing: true));
    });
    on<VoiceRecognitionStop>((event, emit) {
      VoskFlutterPlugin.stop();
      emit(state.copyWith(isRecognizing: false));
    });
  }

  Future<void> initModel(void Function() onInitiated) async {
    ByteData modelZip =
        await rootBundle.load('assets/models/vosk-model-small-en-us-0.15.zip');
    await VoskFlutterPlugin.initModel(modelZip);
    onInitiated();
  }
}
