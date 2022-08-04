import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/acroulette/acroulette_bloc.dart';
import 'simple_bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(MyApp()),
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  late FlutterTts flutterTts;

  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acroulette',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Acroulette'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
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
              create: (_) => AcrouletteBloc(flutterTts),
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
                    figure = (state as AcrouletteCommandRecognizedState)
                        .currentFigure;
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
                    padding: EdgeInsets.only(top: 50.0),
                    child: Column(children: [
                      Text(text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 36.0, fontWeight: FontWeight.w400)),
                      if (figure != "")
                        Text(figure,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 36.0, fontWeight: FontWeight.w400)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (state.runtimeType == AcrouletteInitialState)
                              _buildButtonColumn(
                                  Colors.green,
                                  Colors.greenAccent,
                                  Icons.play_arrow,
                                  'PLAY',
                                  () => context
                                      .read<AcrouletteBloc>()
                                      .add(AcrouletteStart()))
                            else
                              _buildButtonColumn(
                                  Colors.red,
                                  Colors.redAccent,
                                  Icons.stop,
                                  'STOP',
                                  () => context
                                      .read<AcrouletteBloc>()
                                      .add(AcrouletteStop())),
                          ]),
                    ]));
              }),
            )
          ],
        ),
      ),
    );
  }

  Column _buildButtonColumn(Color color, Color splashColor, IconData icon,
      String label, Function func) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(icon, size: 36.0),
              color: color,
              splashColor: splashColor,
              onPressed: () => func()),
          Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.w400,
                      color: color)))
        ]);
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }
}
