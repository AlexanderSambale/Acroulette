import 'package:acroulette/bloc/acroulette/acroulette_bloc.dart';
import 'package:acroulette/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FlutterTts flutterTts;

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();
    _setAwaitOptions();
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // Column is also a layout widget. It takes a list of children and
      // arranges them vertically. By default, it sizes itself to fit its
      // children horizontally, and tries to be as tall as its parent.
      //
      // Invoke "debug painting" (press "p" in the console, choose the
      // "Toggle Debug Paint" action from the Flutter Inspector in Android
      // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
      // to see the wireframe for each widget.
      //
      // Column has various properties to control how it sizes itself and
      // how it positions its children. Here we use mainAxisAlignment to
      // center the children vertically; the main axis here is the vertical
      // axis because Columns are vertical (the cross axis would be
      // horizontal).
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        BlocProvider(
          create: (_) => AcrouletteBloc(flutterTts,
              settings: objectbox.settingsBox.getAll(),
              possibleFigures: objectbox.positionBox
                  .getAll()
                  .map<String>((element) => element.name)
                  .toList()),
          child: BlocBuilder<AcrouletteBloc, BaseAcrouletteState>(
              buildWhen: (previous, current) {
            return true;
          }, builder: (BuildContext context, state) {
            String text;
            String figure = "";
            switch (state.runtimeType) {
              case AcrouletteInitModel:
                text = "Loading languagemodel!";
                break;
              case AcrouletteModelInitiatedState:
                text = "Starting voice recognition!";
                break;
              case AcrouletteCommandRecognizedState:
                figure =
                    (state as AcrouletteCommandRecognizedState).currentFigure;
                text = "Listening to voice commands!";
                break;
              case AcrouletteVoiceRecognitionStartedState:
              case AcrouletteRecognizeCommandState:
                text = "Listening to voice commands!";
                break;
              default:
                text = "Click the play button to start the game!";
            }
            Column controls;
            switch (state.runtimeType) {
              case AcrouletteInitialState:
              case AcrouletteInitModel:
                {
                  Color color = Colors.amber;
                  Color splashColor = Colors.amberAccent;
                  controls = _controls([
                    controlButton(
                        color,
                        splashColor,
                        Icons.launch,
                        () => context
                            .read<AcrouletteBloc>()
                            .add(AcrouletteStart()))
                  ], stateWidgetLabel(color, 'Initialize Model'));
                  break;
                }
              case AcrouletteModelInitiatedState:
                {
                  Color color = Colors.green;
                  Color splashColor = Colors.greenAccent;
                  controls = _controls([
                    controlButton(
                        color,
                        splashColor,
                        Icons.play_arrow,
                        () => context
                            .read<AcrouletteBloc>()
                            .add(AcrouletteStart()))
                  ], stateWidgetLabel(color, 'PLAY'));
                  break;
                }
              default:
                {
                  Color color = Colors.red;
                  Color splashColor = Colors.redAccent;
                  controls = _controls([
                    controlButton(
                        Colors.black,
                        Colors.black,
                        Icons.skip_previous,
                        () => context
                            .read<AcrouletteBloc>()
                            .add(AcrouletteStop())),
                    controlButton(
                        color,
                        splashColor,
                        Icons.stop,
                        () => context
                            .read<AcrouletteBloc>()
                            .add(AcrouletteStop())),
                    controlButton(
                        Colors.black,
                        Colors.black,
                        Icons.skip_next,
                        () => context
                            .read<AcrouletteBloc>()
                            .add(AcrouletteStop()))
                  ], stateWidgetLabel(color, 'STOP'));
                }
            }
            return Container(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(children: [
                  Text(text,
                      textAlign: TextAlign.center, style: displayTextStyle),
                  if (figure != "")
                    Text(figure,
                        textAlign: TextAlign.center, style: displayTextStyle),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [controls]),
                ]));
          }),
        )
      ],
    );
  }
}

Column _controls(List<Widget> rowChildren, Widget stateWidgetLabel) {
  return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Row(children: rowChildren), stateWidgetLabel]);
}

Widget controlButton(
    Color color, Color splashColor, IconData icon, Function func) {
  return IconButton(
      icon: Icon(icon, size: 36.0),
      color: color,
      splashColor: splashColor,
      onPressed: () => func());
}

Widget stateWidgetLabel(Color color, String label) {
  return Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: Text(label,
          style: TextStyle(
              fontSize: 36.0, fontWeight: FontWeight.w400, color: color)));
}

TextStyle displayTextStyle =
    const TextStyle(fontSize: 36.0, fontWeight: FontWeight.w400);
