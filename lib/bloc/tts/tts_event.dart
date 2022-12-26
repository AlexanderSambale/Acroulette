part of 'tts_bloc.dart';

abstract class TtsEvent extends Equatable {
  const TtsEvent();

  @override
  List<Object> get props => [];
}

class TtsChangeEvent extends TtsEvent {
  final String property;
  const TtsChangeEvent(this.property);
}

class TtsIdleEvent extends TtsEvent {
  const TtsIdleEvent();
}
