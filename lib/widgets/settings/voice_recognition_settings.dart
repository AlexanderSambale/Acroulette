import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/widgets/formWidgets/heading.dart';
import 'package:acroulette/widgets/formWidgets/text_settings_form_field.dart';
import 'package:flutter/material.dart';

class VoiceRecognitionSettings extends StatefulWidget {
  const VoiceRecognitionSettings({Key? key}) : super(key: key);

  @override
  State<VoiceRecognitionSettings> createState() => _VoiceRecognitionSettings();
}

class _VoiceRecognitionSettings extends State<VoiceRecognitionSettings> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView(shrinkWrap: true, children: [
        const Heading(headingLabel: "Voice recognition commands"),
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
    );
  }
}
