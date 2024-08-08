import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/storage_provider.dart';
import 'package:acroulette/widgets/flows.dart';
import 'package:acroulette/widgets/home.dart';
import 'package:acroulette/widgets/positions.dart';
import 'package:acroulette/widgets/privacy_policy.dart';
import 'package:acroulette/widgets/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'simple_bloc_observer.dart';
import 'widgets/license.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StorageProvider storageProvider = await StorageProvider.create(null);
  Bloc.observer = SimpleBlocObserver();
  runApp(Acroulette(storageProvider: storageProvider));
}

class Acroulette extends StatelessWidget {
  const Acroulette({super.key, required this.storageProvider});
  final StorageProvider storageProvider;

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
      home: RepositoryProvider(
        create: (context) => storageProvider,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (BuildContext context) => VoiceRecognitionBloc(),
            ),
            BlocProvider(
              create: (BuildContext context) => TtsBloc(storageProvider),
            ),
          ],
          child: const AcrouletteHomePage(title: 'Acroulette'),
        ),
      ),
    );
  }
}

class AcrouletteHomePage extends StatefulWidget {
  const AcrouletteHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<AcrouletteHomePage> createState() => _AcrouletteHomePageState();
}

class _AcrouletteHomePageState extends State<AcrouletteHomePage> {
  _AcrouletteHomePageState();

  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const Positions(),
    const Flows(),
    const Settings(),
    const PrivacyPolicy(),
    const License()
  ];

  @override
  Widget build(BuildContext context) {
    VoiceRecognitionBloc voiceRecognitionBloc =
        context.read<VoiceRecognitionBloc>();

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
          BottomNavigationBarItem(
            icon: Icon(Icons.copyright, color: Colors.black),
            label: 'License',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: (int index) => setState(() {
          if (_selectedIndex != index) {
            voiceRecognitionBloc.add(VoiceRecognitionStop());
            _selectedIndex = index;
          }
        }),
      ),
    );
  }
}
