import 'package:acroulette/constants/commands.dart';
import 'package:acroulette/widgets/formWidgets/text_settings_form_field.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

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
          ...TextSettingsFormField(NEW_POSITION),
          ...TextSettingsFormField(NEXT_POSITION),
          ...TextSettingsFormField(PREVIOUS_POSITION),
          ...TextSettingsFormField(CURRENT_POSITION),
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
        ],
      ),
    );
  }
}
