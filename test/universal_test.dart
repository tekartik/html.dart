library;

import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_html/html_universal.dart';
import 'package:test/test.dart';

void main() {
  final html = htmlProviderUniversal;
  testMain(html);
}

void testMain(HtmlProvider html) {
  group('universal', () {
    test('currentHtmlDocument', () {
      if (kDartIsWeb) {
        // ignore: avoid_print
        print(currentHtmlDocument.html.innerHtml);
      }
    });
  });
}
