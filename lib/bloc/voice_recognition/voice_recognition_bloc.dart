import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:vosk_flutter/vosk_flutter.dart';

part 'voice_recognition_event.dart';
part 'voice_recognition_state.dart';

class VoiceRecognitionBloc
    extends Bloc<VoiceRecognitionEvent, VoiceRecognitionState> {
  void Function() onInitiated = () {};
  bool isModelLoaded = false;
  VoskFlutterPlugin vosk = VoskFlutterPlugin.instance();
  late Model model;
  late int sampleRate = 44100;
  late SpeechService speechService;

  VoiceRecognitionBloc() : super(const VoiceRecognitionState.initial()) {
    on<VoiceRecognitionStart>((event, emit) async {
      await speechService.start();
      event.onRecognitionStarted();
      speechService.onResult().listen(event.onData);
      emit(state.copyWith(isRecognizing: true));
    });
    on<VoiceRecognitionStop>((event, emit) {
      speechService.stop();
      emit(state.copyWith(isRecognizing: false));
    });

    initModel();
  }

  Future<void> initModel() async {
    final enSmallModelPath = await ModelLoader()
        .loadFromAssets('assets/models/vosk-model-small-en-us-0.15.zip');
    model = await vosk.createModel(enSmallModelPath);
    final recognizer = await vosk.createRecognizer(
      model: model,
      sampleRate: sampleRate,
    );
    speechService = await vosk.initSpeechService(recognizer);
    isModelLoaded = true;
    onInitiated();
  }

  void initialize(void Function() onInitiated) {
    isModelLoaded ? onInitiated() : this.onInitiated = onInitiated;
  }
}
