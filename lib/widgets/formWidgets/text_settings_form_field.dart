import 'package:acroulette/domain_layer/settings_repository.dart';
import 'package:flutter/material.dart';

FutureBuilder<List<Widget>> textSettingsFormField(
    String key, SettingsRepository settingsRepository) {
  Future<List<Widget>> future = Future(() async => [
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
          initialValue: await settingsRepository.getSettingsPairValueByKey(key),
          onSaved: (newValue) async => await settingsRepository
              .putSettingsPairValueByKey(key, newValue!),
        ),
      ]);
  return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        if (snapshot.hasData) {
          return Wrap(children: snapshot.data!);
        } else if (snapshot.hasError) {
          return const Text('Error loading privacy policy...');
        } else {
          return const Text('Loading privacy policy ...');
        }
      });
}
