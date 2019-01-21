@TestOn("browser")
library all_tests_browser.dart;

import 'package:dev_test/test.dart';
import 'package:tekartik_html/html_browser.dart';
import 'package:tekartik_html/html_html5lib.dart' as html5lib;

import 'test_runner.dart' as all_tests;

void main() {
  group('dart:html', () {
    all_tests.testMain(htmlProviderBrowser);
  });

  group('html5lib', () {
    all_tests.testMain(html5lib.htmlProviderHtml5Lib);
  });
}
