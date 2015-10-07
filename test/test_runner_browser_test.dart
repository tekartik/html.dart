@TestOn("browser")
library all_tests_browser.dart;

import 'package:dev_test/test.dart';

import 'test_runner.dart' as all_tests;
import 'package:tekartik_html/html_browser.dart';
import 'package:tekartik_html/html_html5lib.dart' as html5lib;

void main() {
  group('dart:html', () {
    all_tests.test_main(htmlProviderBrowser);
  });

  group('html5lib', () {
    all_tests.test_main(html5lib.htmlProviderHtml5Lib);
  });
}
