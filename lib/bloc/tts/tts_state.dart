part of 'tts_bloc.dart';

abstract class TtsState extends Equatable {
  const TtsState();
  
  @override
  List<Object> get props => [];
}

class TtsInitial extends TtsState {}
