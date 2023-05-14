import 'package:acroulette/constants/widgets.dart';
import 'package:flutter/widgets.dart';

TableRow createLicenseTableRowHeader() {
  return TableRow(children: <Widget>[
    Center(child: styleLicenseText("Package Name")),
    styleLicenseText("License"),
    Center(child: styleLicenseText("Website")),
  ]);
}

Text styleLicenseText(String text) {
  return Text(text,
      style: const TextStyle(fontSize: size, fontWeight: FontWeight.w400));
}
