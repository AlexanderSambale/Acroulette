part of 'voice_recognition_bloc.dart';

class VoiceRecognitionBaseState extends Equatable {
  bool isRecognizing;
  VoiceRecognitionBaseState(this.isRecognizing);

  @override
  List<Object> get props => [isRecognizing];
}

class VoiceRecognitionState extends VoiceRecognitionBaseState {
  final Stream<dynamic> onResult = VoskFlutterPlugin.onResult();
  VoiceRecognitionState(bool isRecognizing) : super(isRecognizing);
  VoiceRecognitionState.initial() : super(false);

  @override
  List<Object> get props => [isRecognizing, onResult];
}
