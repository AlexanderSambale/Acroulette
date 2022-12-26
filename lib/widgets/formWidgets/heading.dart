import 'package:flutter/widgets.dart';

class Heading extends StatelessWidget {
  final String headingLabel;

  const Heading({super.key, required this.headingLabel});

  @override
  Widget build(BuildContext context) {
    return Text(
      headingLabel,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18),
    );
  }
}
