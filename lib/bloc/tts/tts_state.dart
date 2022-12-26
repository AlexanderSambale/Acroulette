part of 'tts_bloc.dart';

abstract class TtsState extends Equatable {
  const TtsState();

  @override
  List<Object> get props => [];
}

class TtsIdleState extends TtsState {}

class TtsChangeState extends TtsState {}
