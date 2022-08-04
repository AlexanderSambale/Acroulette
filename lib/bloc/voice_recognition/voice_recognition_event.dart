part of 'voice_recognition_bloc.dart';

@immutable
abstract class VoiceRecognitionEvent {}

class VoiceRecognitionStart extends VoiceRecognitionEvent {
  final void Function(dynamic event) onData;
  final void Function() onInitiated;
  final void Function() onRecognitionStarted;
  VoiceRecognitionStart(
      this.onData, this.onInitiated, this.onRecognitionStarted);
}

class VoiceRecognitionStop extends VoiceRecognitionEvent {}
