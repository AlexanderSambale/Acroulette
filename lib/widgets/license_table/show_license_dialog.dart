import 'package:flutter/material.dart';

class ShowLicenseDialog extends StatelessWidget {
  final String license;

  const ShowLicenseDialog({super.key, required this.license});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // place the logout at the end of the drawer
                children: <Widget>[
                  Flexible(
                      child: ListView(
                    children: [
                      Text(license),
                    ],
                  )),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Go Back'))
                ])));
  }
}
