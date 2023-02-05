import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:acroulette/widgets/flows.dart';
import 'package:acroulette/widgets/home.dart';
import 'package:acroulette/widgets/positions.dart';
import 'package:acroulette/widgets/privacy_policy.dart';
import 'package:acroulette/widgets/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'simple_bloc_observer.dart';

late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create(null);
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  static late VoiceRecognitionBloc voiceRecognitionBloc;
  static late TtsBloc ttsBloc;

  @override
  initState() {
    super.initState();
    voiceRecognitionBloc = VoiceRecognitionBloc();
    ttsBloc = TtsBloc(objectbox);
  }

  @override
  void dispose() {
    ttsBloc.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    Home(
      voiceRecognitionBloc: voiceRecognitionBloc,
      ttsBloc: ttsBloc,
    ),
    const Positions(),
    const Flows(),
    Settings(
      ttsBloc: ttsBloc,
    ),
    const PrivacyPolicy()
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex != index) {
        voiceRecognitionBloc.add(VoiceRecognitionStop());
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          leading: Image.asset("assets/launcher/acroulette_icon.png",
              fit: BoxFit.contain),
          title: Text(widget.title)),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement, color: Colors.black),
            label: 'Positions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flip_camera_android_rounded, color: Colors.black),
            label: 'Flows',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.black),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, color: Colors.black),
            label: 'Privacy Policy',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
