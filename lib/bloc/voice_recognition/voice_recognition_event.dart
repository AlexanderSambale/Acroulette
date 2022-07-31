part of 'voice_recognition_bloc.dart';

@immutable
abstract class VoiceRecognitionEvent {}

class VoiceRecognitionStart extends VoiceRecognitionEvent {
  final void Function(dynamic event) onData;
  VoiceRecognitionStart(this.onData);
}

class VoiceRecognitionStop extends VoiceRecognitionEvent {}
