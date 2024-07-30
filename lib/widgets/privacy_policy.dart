import 'package:acroulette/helper/io/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: loadPrivacyPolicy(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Markdown(data: replaceHeader(snapshot.data));
          } else if (snapshot.hasError) {
            return const Text('Error loading privacy policy...');
          } else {
            return const Text('Loading privacy policy ...');
          }
        });
  }

  static String replaceHeader(String data) {
    RegExp headerWithTitle =
        RegExp(r'---\n(.|\n)*title: (?<Title>.*)\n(.|\n)*---\n');
    RegExpMatch? match = headerWithTitle.firstMatch(data);
    if (match == null) {
      return data;
    }
    String newHeader = '# ${match.namedGroup('Title')}\n\n';
    return data.replaceFirst(headerWithTitle, newHeader);
  }
}
