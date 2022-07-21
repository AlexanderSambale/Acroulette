part of 'voice_recognition_bloc.dart';

abstract class VoiceRecognitionState extends Equatable {
  final bool isRecognizing = false;
  final Stream<dynamic> onResult = VoskFlutterPlugin.onResult();
  VoiceRecognitionState();

  @override
  List<Object> get props => [isRecognizing];
}

class VoiceRecognitionInitial extends VoiceRecognitionState {}
