import 'package:acroulette/widgets/formWidgets/heading.dart';
import 'package:flutter/material.dart';

class ImportExportSettingsView extends StatelessWidget {
  final void Function() import;
  final void Function() export;

  const ImportExportSettingsView(
      {super.key, required this.import, required this.export});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView(shrinkWrap: true, children: [
        const Heading(headingLabel: "Import and Export"),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: ElevatedButton(
            onPressed: import,
            child: const Text('Import'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: ElevatedButton(
            onPressed: export,
            child: const Text('Export'),
          ),
        ),
      ]),
    );
  }
}
