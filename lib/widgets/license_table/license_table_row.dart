import 'package:acroulette/oss_licenses.dart';
import 'package:acroulette/widgets/license_table/show_license_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

TableRow createLicenseTableRow(Package package, BuildContext context) {
  return TableRow(
    children: <Widget>[
      Text(package.name),
      package.license == null
          ? Container()
          : RichText(
              text: TextSpan(
                  text: 'Show License',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ShowLicenseDialog(
                                  license: package.license!);
                            }).then((exit) {
                          if (exit) return;
                        }),
                  style: const TextStyle(
                    color: Colors.blue,
                  ))),
      package.homepage == null
          ? Container()
          : RichText(
              text: TextSpan(
                  text: package.homepage!,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => {launchUrl(Uri.parse(package.homepage!))},
                  style: const TextStyle(
                    color: Colors.blue,
                  )))
    ],
  );
}
