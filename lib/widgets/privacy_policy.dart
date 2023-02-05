import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

Future<String> loadAsset(BuildContext context) async {
  return await DefaultAssetBundle.of(context)
      .loadString('assets/docs/privacy_policy.md');
}

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: loadAsset(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Markdown(data: snapshot.data);
          } else if (snapshot.hasError) {
            return const Text('Error loading privacy policy...');
          } else {
            return const Text('Loading privacy policy ...');
          }
        });
  }
}
