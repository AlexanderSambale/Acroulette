part of 'voice_recognition_bloc.dart';

class VoiceRecognitionBaseState extends Equatable {
  final bool isRecognizing;
  const VoiceRecognitionBaseState(this.isRecognizing);

  @override
  List<Object> get props => [isRecognizing];
}

class VoiceRecognitionState extends VoiceRecognitionBaseState {
  const VoiceRecognitionState(super.isRecognizing);
  const VoiceRecognitionState.initial() : super(false);

  VoiceRecognitionState copyWith({
    required bool isRecognizing,
  }) {
    return VoiceRecognitionState(isRecognizing);
  }

  @override
  List<Object> get props => [isRecognizing];
}
