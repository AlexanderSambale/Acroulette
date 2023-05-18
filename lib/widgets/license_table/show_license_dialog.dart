import 'package:acroulette/constants/widgets.dart';
import 'package:flutter/material.dart';

class ShowLicenseDialog extends StatelessWidget {
  final String license;
  final String projectName;

  const ShowLicenseDialog(
      {super.key, required this.projectName, required this.license});

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
                  Row(children: [
                    Expanded(
                        child: Card(
                            color: Colors.blue,
                            child: Center(
                                child: Text(projectName,
                                    style:
                                        const TextStyle(color: Colors.white)))))
                  ]),
                  Container(height: size / 2),
                  Flexible(
                      child: ListView(
                    children: [
                      Text(license),
                    ],
                  )),
                  Container(height: size / 2),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Go Back'))
                ])));
  }
}
