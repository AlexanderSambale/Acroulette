import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/widgets/settings/import_export_settings.dart';
import 'package:acroulette/widgets/settings/tts_settings.dart';
import 'package:acroulette/widgets/settings/voice_recognition_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: ImportExportSettings()),
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: VoiceRecognitionSettings(
                  voiceRecognitionBloc: context.read<VoiceRecognitionBloc>())),
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: TtsSettings(ttsBloc: context.read<TtsBloc>())),
        ],
      ),
    );
  }
}
