import 'package:acroulette/oss_licenses.dart';
import 'package:acroulette/widgets/license_table/show_license_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

TableRow createLicenseTableRow(Package package, BuildContext context) {
  String homepage = package.homepage == null
      ? 'https://pub.dev/packages/${package.name}'
      : package.homepage!;
  return TableRow(
    children: <Widget>[
      RichText(
          text: TextSpan(
              text: package.name,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrl(Uri.parse(homepage));
                },
              style: const TextStyle(
                color: Colors.blue,
              ))),
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
                                license: package.license!,
                                projectName: package.name,
                              );
                            }).then((exit) {
                          if (exit) return;
                        }),
                  style: const TextStyle(
                    color: Colors.blue,
                  )))
    ],
  );
}
