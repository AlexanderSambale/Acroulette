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
        child: ListView(
          children: [
            Text(license),
            ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Go Back'))
          ],
        ));
  }
}
