import 'package:acroulette/oss_licenses.dart';
import 'package:acroulette/widgets/license_table/show_license_dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

TableRow createLicenseTableRow(Package package, BuildContext context) {
  return TableRow(
    children: <Widget>[
      Text(package.name),
      package.license == null
          ? Text("")
          : ElevatedButton(
              onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ShowLicenseDialog(license: package.license!);
                      }).then((exit) {
                    if (exit) return;
                  }),
              child: const Text('Show License')),
      package.homepage == null
          ? Text("")
          : ElevatedButton(
              onPressed: () => {launchUrl(Uri.parse(package.homepage!))},
              child: Text(package.homepage!))
    ],
  );
}
