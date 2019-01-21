library document_test;

import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/html_html5lib.dart';
import 'package:tekartik_html/util/html_tidy.dart';
import 'package:dev_test/test.dart';

void main() {
  HtmlProvider html = htmlProviderHtml5Lib;
  testMain(html);
}

void testMain(HtmlProvider html) {
  group('tidy_document', () {
    test('html_attributes', () {
      Document doc = html.createDocument(title: 'test');
      doc.html.attributes['⚡'] = '';
      expect(htmlTidyDocument(doc), [
        '<!DOCTYPE html>',
        '<html ⚡>',
        '<head>',
        '\t<meta charset="utf-8">',
        '\t<title>test</title>',
        '</head>',
        '<body></body>',
        '</html>'
      ]);
    });
    test('amp_basic', () {
      Document doc = html.createDocument(html: '''
<!doctype html>
<html ⚡ lang="en">
<head>
    <meta charset="utf-8">
    <title>Basic</title>
    <link rel="canonical" href="hello-world.html" >
    <meta name="viewport" content="width=device-width,minimum-scale=1,initial-scale=1">
    <!-- only one style tag is allowed, and it must have an "amp-custom" attribute -->
    <style amp-custom>
    </style>
    <!-- this style tag is required -->
    <style>body {opacity: 0}</style><noscript><style>body {opacity: 1}</style></noscript>
    <script async src="https://cdn.ampproject.org/v0.js"></script>
</head>
<body>Hello World!</body>
</html>''');
      expect(htmlTidyDocument(doc).join('\n'), '''
<!DOCTYPE html>
<html ⚡ lang="en">
<head>
\t<meta charset="utf-8">
\t<title>Basic</title>
\t<link rel="canonical" href="hello-world.html">
\t<meta name="viewport" content="width=device-width,minimum-scale=1,initial-scale=1">
\t<style amp-custom>
\t</style>
\t<style>body {opacity: 0}</style>
\t<noscript><style>body {opacity: 1}</style></noscript>
\t<script async src="https://cdn.ampproject.org/v0.js"></script>
</head>
<body>
\tHello World!
</body>
</html>''');
    });
  });
}
