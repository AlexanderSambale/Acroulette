import 'package:acroulette/models/helper/import_export/export.dart';
import 'package:acroulette/models/helper/import_export/import.dart';
import 'package:acroulette/widgets/formWidgets/import_export_settings_view.dart';
import 'package:flutter/material.dart';

class ImportExportSettings extends StatelessWidget {
  const ImportExportSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ImportExportSettingsView(
        import: () => import(dbController), export: () => export(dbController));
  }
}
