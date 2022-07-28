library universal_test;

import 'package:dev_test/test.dart';
import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_html/html_universal.dart';

void main() {
  final html = htmlProviderUniversal;
  testMain(html);
}

void testMain(HtmlProvider html) {
  group('universal', () {
    test('currentHtmlDocument', () {
      if (isRunningAsJavascript) {
        currentHtmlDocument.body;
      }
    });
  });
}
