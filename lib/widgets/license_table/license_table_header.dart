import 'package:acroulette/constants/widgets.dart';
import 'package:flutter/widgets.dart';

TableRow createLicenseTableRowHeader() {
  return TableRow(children: <Widget>[
    Center(child: styleLicenseText("Package Name")),
    styleLicenseText("License"),
    Center(child: styleLicenseText("Website")),
  ]);
}

Text styleLicenseText(String text, {double fontSize = size}) {
  return Text(text,
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w400));
}
