import 'package:acroulette/main.dart';
import 'package:flutter/material.dart';

List<Widget> textSettingsFormField(String key) {
  return [
    Text(key),
    TextFormField(
      decoration: InputDecoration(
        hintText: key,
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      initialValue: objectbox.getSettingsPairValueByKey(key),
      onSaved: (newValue) =>
          objectbox.putSettingsPairValueByKey(key, newValue!),
    ),
  ];
}
