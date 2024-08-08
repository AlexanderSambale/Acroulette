import 'package:acroulette/domain_layer/flow_node_repository.dart';
import 'package:acroulette/domain_layer/node_repository.dart';
import 'package:acroulette/helper/import_export/export.dart';
import 'package:acroulette/helper/import_export/import.dart';
import 'package:acroulette/widgets/formWidgets/import_export_settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportExportSettings extends StatelessWidget {
  const ImportExportSettings({super.key});

  @override
  Widget build(BuildContext context) {
    NodeRepository nodeRepository = context.read<NodeRepository>();
    FlowNodeRepository flowNodeRepository = context.read<FlowNodeRepository>();

    return ImportExportSettingsView(
      import: () => import(
        nodeRepository,
        flowNodeRepository,
      ),
      export: () => export(
        nodeRepository,
        flowNodeRepository,
      ),
    );
  }
}
