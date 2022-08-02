import 'package:acroulette/bloc/transition/transition_bloc.dart';
import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';

part 'acroulette_event.dart';
part 'acroulette_state.dart';

class AcrouletteBloc extends Bloc<AcrouletteEvent, BaseAcrouletteState> {
  AcrouletteBloc(this.flutterTts) : super(AcrouletteInitialState()) {
    on<AcrouletteStart>((event, emit) {
      voiceRecognitionBloc.add(VoiceRecognitionStart(onData));
      emit(AcrouletteStartState());
    });
    on<AcrouletteStop>((event, emit) {
      voiceRecognitionBloc.add(VoiceRecognitionStop());
    });
    on<AcrouletteRecognizeCommand>(
        (event, emit) => {recognizeCommand(event.command)});
  }

  late final transitionBloc = TransitionBloc(onTransitionChange);
  final voiceRecognitionBloc = VoiceRecognitionBloc();
  final ttsBloc = TtsBloc();
  final FlutterTts flutterTts;
  RegExp rNextPosition = new RegExp(r"next position");
  RegExp rNewPosition = new RegExp(r"new position");

  void onTransitionChange() {
    print("test");
/*     if (transitionBloc.state.status == TransitionStatus.create) {
      _speak(transitionBloc.currentFigure());
    } */
  }

  void onData(dynamic event) {
    add(AcrouletteRecognizeCommand(event));
  }

  void recognizeCommand(String command) {
    final Map<String, dynamic> commandMapped = jsonDecode(command);
    final text = commandMapped["text"];
    print(text);
    if (rNewPosition.hasMatch(text)) {
      transitionBloc.add(NewTransitionEvent());
    }
    if (rNextPosition.hasMatch(text)) {
      transitionBloc.add(NextTransitionEvent());
      _speak(transitionBloc.currentFigure());
    }
  }

  Future _speak(String text) async {
    double volume = 0.5;
    double pitch = 1.0;
    double rate = 0.5;
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    await flutterTts.speak(text);
  }
}
