import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/widgets/formWidgets/text_settings_form_field.dart';
import 'package:acroulette/widgets/settings/tts.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final TtsBloc ttsBloc;

  const Settings({Key? key, required this.ttsBloc}) : super(key: key);

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
          Card(
            child: ListView(shrinkWrap: true, children: [
              const Text("Voice recognition commands",
                  textAlign: TextAlign.center),
              ...textSettingsFormField(newPosition),
              ...textSettingsFormField(nextPosition),
              ...textSettingsFormField(previousPosition),
              ...textSettingsFormField(currentPosition),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ]),
          ),
          TtsSettings(ttsBloc: widget.ttsBloc)
        ],
      ),
    );
  }
}
