import 'package:acroulette/db_controller.dart';
import 'package:acroulette/helper/import_export/export.dart';
import 'package:acroulette/helper/import_export/import.dart';
import 'package:acroulette/widgets/formWidgets/import_export_settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportExportSettings extends StatelessWidget {
  const ImportExportSettings({super.key});

  @override
  Widget build(BuildContext context) {
    DBController dbController = context.read<DBController>();

    return ImportExportSettingsView(
        import: () => import(dbController), export: () => export(dbController));
  }
}
