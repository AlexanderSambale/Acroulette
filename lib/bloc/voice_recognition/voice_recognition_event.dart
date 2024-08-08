part of 'voice_recognition_bloc.dart';

@immutable
abstract class VoiceRecognitionEvent {}

class VoiceRecognitionStart extends VoiceRecognitionEvent {
  final void Function(dynamic event) onData;
  final Future<void> Function() onRecognitionStarted;
  VoiceRecognitionStart(this.onData, this.onRecognitionStarted);
}

class VoiceRecognitionStop extends VoiceRecognitionEvent {}
