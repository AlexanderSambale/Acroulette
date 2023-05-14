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
        children: rows,
      )
    ]);
  }
}
