part of 'voice_recognition_bloc.dart';
import 'package:vosk_flutter_plugin/vosk_flutter_plugin.dart';

abstract class VoiceRecognitionState extends Equatable {
  final bool isRecognizing = false;
  Stream<dynamic> onResult = VoskFlutterPlugin.onResult()
  const VoiceRecognitionState();

  @override
  List<Object> get props => [isRecognizing];
}

class VoiceRecognitionInitial extends VoiceRecognitionState {}
