import 'package:acroulette/db_controller.dart';
import 'package:flutter/material.dart';

FutureBuilder<List<Widget>> textSettingsFormField(
    String key, DBController dbController) {
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
          initialValue: await dbController.getSettingsPairValueByKey(key),
          onSaved: (newValue) async =>
              await dbController.putSettingsPairValueByKey(key, newValue!),
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
