@TestOn('browser')
library;

import 'package:tekartik_html/html_html5lib.dart' as html5lib;
import 'package:tekartik_html/html_universal.dart' as universal;
import 'package:tekartik_html/html_web.dart';
import 'package:test/test.dart';

import 'test_runner.dart' as all_tests;

void main() {
  group('universal', () {
    all_tests.testMain(universal.htmlProviderUniversal);
  });

  group('web', () {
    all_tests.testMain(htmlProviderWeb);
  });

  group('html5lib', () {
    all_tests.testMain(html5lib.htmlProviderHtml5Lib);
  });
}
