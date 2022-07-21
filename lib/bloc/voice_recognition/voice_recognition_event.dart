part of 'voice_recognition_bloc.dart';

@immutable
abstract class VoiceRecognitionEvent {}

class VoiceRecognitionStart extends VoiceRecognitionEvent {}

class VoiceRecognitionStop extends VoiceRecognitionEvent {}
