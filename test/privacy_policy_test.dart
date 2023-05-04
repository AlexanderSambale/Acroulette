import 'package:acroulette/widgets/privacy_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PrivacyPolicy.replaceHeader', () {
    String input = '''---
layout: ../../layouts/RequiredDocs.astro
description: Privacy Policy - Acroulette App 
title: Privacy Policy - Acroulette App
---
## Permissions''';
    String result = '''# Privacy Policy - Acroulette App

## Permissions''';
    expect(PrivacyPolicy.replaceHeader(input), equals(result));
  });
}
