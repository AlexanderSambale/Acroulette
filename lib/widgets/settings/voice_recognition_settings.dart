import 'package:acroulette/bloc/voice_recognition/voice_recognition_bloc.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/domain_layer/settings_repository.dart';
import 'package:acroulette/widgets/formWidgets/heading.dart';
import 'package:acroulette/widgets/formWidgets/text_settings_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoiceRecognitionSettings extends StatefulWidget {
  final VoiceRecognitionBloc voiceRecognitionBloc;

  const VoiceRecognitionSettings(
      {super.key, required this.voiceRecognitionBloc});

  @override
  State<VoiceRecognitionSettings> createState() => _VoiceRecognitionSettings();
}

class _VoiceRecognitionSettings extends State<VoiceRecognitionSettings> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SettingsRepository settingsRepository = context.read<SettingsRepository>();

    return BlocProvider.value(
        value: widget.voiceRecognitionBloc,
        child: BlocBuilder<VoiceRecognitionBloc, VoiceRecognitionState>(
            buildWhen: (previous, current) {
          return true;
        }, builder: (BuildContext context, state) {
          VoiceRecognitionBloc voiceRecognitionBloc =
              context.read<VoiceRecognitionBloc>();
          if (!voiceRecognitionBloc.isModelLoaded) {
            return Form(key: _formKey, child: const Spacer());
          }
          return Form(
              key: _formKey,
              child: Card(
                child: ListView(shrinkWrap: true, children: [
                  const Heading(headingLabel: "Voice recognition commands"),
                  textSettingsFormField(newPosition, settingsRepository),
                  textSettingsFormField(nextPosition, settingsRepository),
                  textSettingsFormField(previousPosition, settingsRepository),
                  textSettingsFormField(currentPosition, settingsRepository),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
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
              ));
        }));
  }
}
