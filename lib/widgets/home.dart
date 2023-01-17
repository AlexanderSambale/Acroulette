import 'package:acroulette/bloc/acroulette/acroulette_bloc.dart';
import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/constants/widgets.dart';
import 'package:acroulette/main.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:acroulette/widgets/loader.dart';
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BlocProvider(
            create: (_) => AcrouletteBloc(
                widget.ttsBloc, objectbox, widget.voiceRecognitionBloc),
            child: BlocBuilder<AcrouletteBloc, BaseAcrouletteState>(
                buildWhen: (previous, current) {
              return ![AcrouletteInitModel, AcrouletteInitialState]
                  .contains(current.runtimeType);
            }, builder: (BuildContext context, state) {
              String text;
              String currentFigure = "";
              String nextFigure = "";
              String previousFigure = "";
              AcrouletteBloc acrouletteBloc = context.read<AcrouletteBloc>();
              var mode = acrouletteBloc.mode;
              var machine = acrouletteBloc.machine;
              switch (state.runtimeType) {
                case AcrouletteModelInitiatedState:
                case AcrouletteFlowState:
                  if (objectbox.getSettingsPairValueByKey(playingKey) ==
                      "true") {
                    return const Loader();
                  }
                  text = "Click the play button to start!";
                  break;
                case AcrouletteCommandRecognizedState:
                  AcrouletteCommandRecognizedState currentState =
                      (state as AcrouletteCommandRecognizedState);
                  currentFigure = currentState.currentFigure;
                  previousFigure = currentState.previousFigure;
                  nextFigure = currentState.nextFigure;
                  text = "Listening to voice commands!";
                  break;
                default:
                  return const Loader();
              }

              return Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(children: [
                    modeSelect(mode, acrouletteBloc),
                    if (mode == washingMachine)
                      washingMachineDropdown(machine, acrouletteBloc),
                    if (currentFigure != "")
                      showPositions(previousFigure, currentFigure, nextFigure,
                          MediaQuery.of(context).size.width),
                    Text(text,
                        textAlign: TextAlign.center, style: displayTextStyle),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [getControls(state, acrouletteBloc, mode)]),
                  ]));
            }),
          )
        ]);
  }
}

Column _controls(List<Widget> rowChildren, Widget stateWidgetLabel) {
  return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: rowChildren),
        stateWidgetLabel
      ]);
}

Widget controlButton(
    Color color, Color splashColor, IconData icon, void Function()? func) {
  return IconButton(
      padding: const EdgeInsets.all(0),
      icon: Icon(icon, size: 2.5 * size),
      color: color,
      splashColor: splashColor,
      onPressed: func);
}

Widget stateWidgetLabel(Color color, String label) {
  return Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: Text(label,
          style: TextStyle(
              fontSize: size, fontWeight: FontWeight.w400, color: color)));
}

const TextStyle displayTextStyle =
    TextStyle(fontSize: size, fontWeight: FontWeight.w400);

TextStyle displayCurrentPostureStyle = const TextStyle(
    fontSize: 1.5 * size, fontWeight: FontWeight.w400, color: Colors.blue);

Widget posture(String figure, double width,
    {TextStyle style = displayTextStyle}) {
  return SizedBox(
      width: width,
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: figure == ""
                  ? noPosture()
                  : Text(
                      figure,
                      textAlign: TextAlign.center,
                      style: style,
                    ))));
}

Widget noPosture() {
  return const Icon(
    Icons.warning,
    size: size,
  );
}

List<DropdownMenuItem<String>> getWashingMachineItems(ObjectBox objectBox) {
  return objectBox.flowNodeBox
      .getAll()
      .map((flow) => DropdownMenuItem<String>(
          value: flow.id.toString(),
          child: Center(child: Text(flow.name, style: displayTextStyle))))
      .toList();
}

Column getControls(
    BaseAcrouletteState state, AcrouletteBloc acrouletteBloc, String mode) {
  switch (state.runtimeType) {
    case AcrouletteInitialState:
    case AcrouletteModelInitiatedState:
    case AcrouletteFlowState:
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
  return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 8.0, right: 8.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: size / 4),
          child: DropdownButton<String>(
            value: mode,
            items: const [acroulette, washingMachine]
                .map<DropdownMenuItem<String>>(((String itemLabel) {
              return DropdownMenuItem(
                  value: itemLabel,
                  child:
                      Center(child: Text(itemLabel, style: displayTextStyle)));
            })).toList(),
            onChanged: (value) {
              if (value == null || mode == value) return;
              acrouletteBloc.add(AcrouletteChangeMode(value));
            },
            isExpanded: true,
            underline: const SizedBox(),
          )));
}

Widget showPositions(
    String previousFigure, String currentFigure, String nextFigure, width) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      posture(previousFigure, width),
      posture(currentFigure, width, style: displayCurrentPostureStyle),
      posture(nextFigure, width),
    ],
  );
}

Widget washingMachineDropdown(String machine, AcrouletteBloc acrouletteBloc) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 8.0, right: 8.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: size / 4),
          child: DropdownButton<String>(
            value: machine,
            items: getWashingMachineItems(objectbox),
            onChanged: (value) {
              if (value == null || machine == value) return;
              acrouletteBloc.add(AcrouletteChangeMachine(value));
            },
            isExpanded: true,
            underline: const SizedBox(),
          )));
}
