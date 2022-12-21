import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tts/flutter_tts.dart';

part 'tts_event.dart';
part 'tts_state.dart';

class TtsBloc extends Bloc<TtsEvent, TtsState> {
  late FlutterTts flutterTts;

  TtsBloc() : super(TtsInitial()) {
    initTts();
    on<TtsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  initTts() {
    flutterTts = FlutterTts();
    _setAwaitOptions();
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future setVolume(double volume) async {
    await flutterTts.setVolume(volume);
  }

  Future setSpeechRate(double rate) async {
    await flutterTts.setSpeechRate(rate);
  }

  Future setPitch(double pitch) async {
    await flutterTts.setPitch(pitch);
  }

  Future speak(String text) async {
    await flutterTts.speak(text);
  }
}
