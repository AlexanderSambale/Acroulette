import 'package:acroulette/bloc/acroulette/acroulette_bloc.dart';
import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/main.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home(
      {Key? key, required this.voiceRecognitionBloc, required this.ttsBloc})
      : super(key: key);

  final TtsBloc ttsBloc;
  final VoiceRecognitionBloc voiceRecognitionBloc;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          create: (_) => AcrouletteBloc(
              widget.ttsBloc, objectbox, widget.voiceRecognitionBloc),
          child: BlocBuilder<AcrouletteBloc, BaseAcrouletteState>(
              buildWhen: (previous, current) {
            return true;
          }, builder: (BuildContext context, state) {
            String text;
            String currentFigure = "";
            String nextFigure = "";
            String previousFigure = "";
            AcrouletteBloc acrouletteBloc = context.read<AcrouletteBloc>();
            var mode = acrouletteBloc.mode;
            var machine = acrouletteBloc.machine;
            switch (state.runtimeType) {
              case AcrouletteInitModel:
                text = "Loading languagemodel!";
                break;
              case AcrouletteModelInitiatedState:
                text = "Starting voice recognition!";
                break;
              case AcrouletteCommandRecognizedState:
                AcrouletteCommandRecognizedState currentState =
                    (state as AcrouletteCommandRecognizedState);
                currentFigure = currentState.currentFigure;
                previousFigure = currentState.previousFigure;
                nextFigure = currentState.nextFigure;
                text = "Listening to voice commands!";
                break;
              case AcrouletteVoiceRecognitionStartedState:
              case AcrouletteRecognizeCommandState:
                text = "Listening to voice commands!";
                break;
              default:
                text = "Click the play button to start the game!";
            }

            return Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  modeSelect(mode, acrouletteBloc),
                  Text(text,
                      textAlign: TextAlign.center, style: displayTextStyle),
                  Container(
                    height: 50,
                  ),
                  if (mode == washingMachine)
                    washingMachineDropdown(machine, acrouletteBloc),
                  if (currentFigure != "")
                    showPositions(previousFigure, currentFigure, nextFigure),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [getControls(state, acrouletteBloc, mode)]),
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

TextStyle displayCurrentPostureStyle = const TextStyle(
    fontSize: 36.0, fontWeight: FontWeight.w400, color: Colors.blue);

Widget postureMiddle(String figure) {
  return Card(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Text(
            figure,
            textAlign: TextAlign.center,
            style: displayCurrentPostureStyle,
          )));
}

Widget noPosture() {
  return const Icon(
    Icons.warning,
    size: 36.0,
  );
}

List<DropdownMenuItem<String>> getWashingMachineItems(ObjectBox objectBox) {
  return objectBox.flowNodeBox
      .getAll()
      .map((flow) => DropdownMenuItem<String>(
          value: flow.id.toString(),
          child: Text(flow.name, style: displayTextStyle)))
      .toList();
}

Column getControls(
    BaseAcrouletteState state, AcrouletteBloc acrouletteBloc, String mode) {
  switch (state.runtimeType) {
    case AcrouletteInitialState:
    case AcrouletteInitModel:
      {
        Color color = Colors.amber;
        Color splashColor = Colors.amberAccent;
        return _controls([
          controlButton(color, splashColor, Icons.launch,
              () => acrouletteBloc.add(AcrouletteStart()))
        ], stateWidgetLabel(color, 'Initialize Model'));
      }
    case AcrouletteModelInitiatedState:
      {
        Color color = Colors.green;
        Color splashColor = Colors.greenAccent;
        return _controls([
          controlButton(color, splashColor, Icons.play_arrow,
              () => acrouletteBloc.add(AcrouletteStart()))
        ], stateWidgetLabel(color, 'PLAY'));
      }
    default:
      {
        Color color = Colors.red;
        Color splashColor = Colors.redAccent;
        return _controls([
          controlButton(Colors.black, Colors.black, Icons.skip_previous,
              () => acrouletteBloc.add(AcrouletteTransition(previousPosition))),
          controlButton(color, splashColor, Icons.stop,
              () => acrouletteBloc.add(AcrouletteStop())),
          controlButton(Colors.black, Colors.black, Icons.skip_next,
              () => acrouletteBloc.add(AcrouletteTransition(nextPosition))),
          if (mode == acroulette)
            controlButton(Colors.black, Colors.black, Icons.add_circle,
                () => acrouletteBloc.add(AcrouletteTransition(newPosition)))
        ], stateWidgetLabel(color, 'STOP'));
      }
  }
}

Widget modeSelect(String mode, AcrouletteBloc acrouletteBloc) {
  return DropdownButton<String>(
    value: mode,
    items: [
      DropdownMenuItem(
          value: acroulette, child: Text(acroulette, style: displayTextStyle)),
      DropdownMenuItem(
          value: washingMachine,
          child: Text(washingMachine, style: displayTextStyle))
    ],
    onChanged: (value) {
      if (value == null || mode == value) return;
      acrouletteBloc.add(AcrouletteChangeMode(value));
    },
  );
}

Widget showPositions(
    String previousFigure, String currentFigure, String nextFigure) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Card(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: previousFigure == ""
                  ? noPosture()
                  : Text(
                      previousFigure,
                      textAlign: TextAlign.center,
                      style: displayTextStyle,
                    ))),
      Container(
        height: 10,
      ),
      postureMiddle(currentFigure),
      Container(
        height: 10,
      ),
      Card(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: nextFigure == ""
                  ? noPosture()
                  : Text(
                      nextFigure,
                      textAlign: TextAlign.center,
                      style: displayTextStyle,
                    )))
    ],
  );
}

Widget washingMachineDropdown(String machine, AcrouletteBloc acrouletteBloc) {
  return DropdownButton<String>(
      value: machine,
      items: getWashingMachineItems(objectbox),
      onChanged: (value) {
        if (value == null || machine == value) return;
        acrouletteBloc.add(AcrouletteChangeMachine(value));
      });
}
