library;

import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_html/html_universal.dart';
import 'package:tekartik_html/util/html_tidy.dart';
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
    test('base doc', () async {
      final doc = html.createDocument();
      if (html is HtmlProviderHtml5Lib) {
        expect(htmlTidyDocument(doc), [
          '<!DOCTYPE html>',
          '<html>',
          '<head>',
          '\t<meta charset="utf-8">',
          '\t<title></title>',
          '</head>',
          '<body></body>',
          '</html>'
        ]);
      } else if (html is HtmlProviderWeb) {
        expect(htmlTidyDocument(doc), [
          '<!DOCTYPE html>',
          '<html>',
          '<head>',
          '\t<meta charset="utf-8">',
          '\t<title></title>',
          '</head>',
          '<body></body>',
          '</html>'
        ]);
      } else {
        fail('unsupported html provider');
      }
    });
  });
}
