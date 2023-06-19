import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<String> loadAsset(String asset) async {
  return await rootBundle.loadString('assets/$asset');
}

Future<String> loadPrivacyPolicy(BuildContext context) async {
  return await DefaultAssetBundle.of(context)
      .loadString('assets/docs/privacy_policy.md');
}
