part of 'voice_recognition_bloc.dart';

abstract class VoiceRecognitionEvent extends Equatable {
  const VoiceRecognitionEvent();

  @override
  List<Object> get props => [];
}

class VoiceRecognitionStart extends VoiceRecognitionEvent {}

class VoiceRecognitionStop extends VoiceRecognitionEvent {}
