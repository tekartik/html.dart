library;

import 'package:tekartik_html/html_html5lib.dart';
import 'package:test/test.dart';

void main() {
  final html = htmlProviderHtml5Lib;
  testMain(html);
}

void testMain(HtmlProvider html) {
  group('document', () {
    test('simple', () {
      final doc = html.createDocument(title: 'test');
      expect(doc.htmlProvider, html);
      expect(doc.toString(),
          '<!DOCTYPE html><html><head><meta charset="utf-8"><title>test</title></head><body></body></html>');
      //print(doc.head.children);
      //print(doc.body);
      expect(doc.body.children.length, 0);
      //print(document.nodes[0].toString());
      //print(document.documentElement.outerHtml);
    });

    test('title', () {
      final doc = html.createDocument(title: 'test');
      expect(doc.title, 'test');
      doc.title = 'update';
      expect(doc.title, 'update');
    });

    test('wrap', () {
      var document = html.createDocument(title: 'test');

      dynamic docImpl = html.unwrapDocument(document);

      document = html.wrapDocument(docImpl);
      expect(document.title, 'test');
    });

    test('head', () {
      var doc = html.createDocument(title: 'test');
      expect(doc.head.innerHtml, '<meta charset="utf-8"><title>test</title>');

      doc = html.createDocument(title: 'test', charset: null);
      expect(doc.head.innerHtml, '<title>test</title>');
      doc.head.appendChild(html
          .createElementHtml(
              '<div><link rel="canonical" href="/index.html"></div>')
          .children
          .first);
    });

    test('html', () {
      final doc = html.createDocument(title: 'test');
      expect(doc.html.innerHtml,
          '<head><meta charset="utf-8"><title>test</title></head><body></body>');
    });

    test('createDocumentHtml', () {
      var doc = html.createDocument(
          html: '<head><title>test</title></head><body></body>');
      expect(doc.toString(),
          '<!DOCTYPE html><html><head><meta charset="utf-8"><title>test</title></head><body></body></html>');
      doc = html.createDocument(
          html: '<html><head><title>test</title></head><body></body></html>');
      expect(doc.toString(),
          '<!DOCTYPE html><html><head><meta charset="utf-8"><title>test</title></head><body></body></html>');
      doc = html.createDocument(
          html: '<!DOCTYPE html><html><head></head><body></body></html>');
      expect(doc.toString(),
          '<!DOCTYPE html><html><head><meta charset="utf-8"><title></title></head><body></body></html>');
    });

    test('custom', () {
      final doc = html.createDocument(html: '''
      <head>
        <meta charset="utf-8">
        <title>test</title>
        <meta property="dtk-include" content="head/some/path/1" />
        <!--<div class="--dtk-include" title="head/some/path/2"></div>-->
      </head>
      <body>
        <div class="--dtk-include" title="some/path/1"></div>
        <meta property="dtk-include" content="some/path/2" />
      </body>
      ''');
      /*print(doc.html.innerHtml);
      for (var child in doc.head.children) {
        print(child.outerHtml);
      }*/
      expect(doc.head.children.length, 3);
      expect(doc.body.children.length, 2);
    });

    test('html_attributes', () {
      // html is a special element that we cannot parse without parsing a document
      final doc = html.createDocument(
          html:
              '<!DOCTYPE html><html ⚡ lang="en"><head><meta charset="utf-8"><title></title></head><body></body></html>');
      expect(doc.html.attributes.length, 2);
      expect(doc.html.attributes['⚡'], '');
      expect(doc.html.attributes['lang'], 'en');

      //expect(doc.toString(), '<!DOCTYPE html><html ⚡="" lang="en"><head><meta charset="utf-8"><title></title></head><body></body></html>');
    });

    test('createDocumentHtml no fix', () {
      final doc = html.createDocument(
          html: '<!DOCTYPE html><html><head></head><body></body></html>',
          noCharsetTitleFix: true);

      expect(doc.toString(),
          '<!DOCTYPE html><html><head></head><body></body></html>');
    });

    test('createDocumentHtml empty', () {
      final doc = html.createDocument(html: '', noCharsetTitleFix: true);
      doc.fixMissing();
      expect(doc.toString(),
          '<!DOCTYPE html><html><head><meta charset="utf-8"><title></title></head><body></body></html>');
    });

    test('fix charset and title', () {
      final doc = html.createDocument(html: '<!DOCTYPE html>');
      expect(doc.toString(),
          '<!DOCTYPE html><html><head><meta charset="utf-8"><title></title></head><body></body></html>');
      doc.fixMissing();
      expect(doc.toString(),
          '<!DOCTYPE html><html><head><meta charset="utf-8"><title></title></head><body></body></html>');
    });
  });
}
