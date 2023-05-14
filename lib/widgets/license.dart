import 'package:acroulette/oss_licenses.dart';
import 'package:acroulette/widgets/license_table/license_table_row.dart';
import 'package:flutter/material.dart';

class License extends StatelessWidget {
  const License({super.key});

  @override
  Widget build(BuildContext context) {
    List<TableRow> rows = ossLicenses
        .map((package) => createLicenseTableRow(package, context))
        .toList();

    return ListView(children: [
      Table(
        columnWidths: const {
          0: FlexColumnWidth(7),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(11),
        },
        children: rows,
      )
    ]);
  }
}
