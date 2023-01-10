part of 'tts_bloc.dart';

abstract class TtsEvent {
  const TtsEvent();
}

class TtsChangeEvent extends TtsEvent {
  final String property;
  const TtsChangeEvent(this.property);
}

class TtsIdleEvent extends TtsEvent {
  const TtsIdleEvent();
}
