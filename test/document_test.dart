library document_test;

import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/html_html5lib.dart';
import 'package:dev_test/test.dart';

main() {
  HtmlProvider html = htmlProviderHtml5Lib;
  test_main(html);
}

test_main(HtmlProvider html) {
  group('document', () {
    test('simple', () {
      Document doc = html.createDocument(title: 'test');
      expect(doc.toString(),
          '<!DOCTYPE html><html><head><meta charset="utf-8"><title>test</title></head><body></body></html>');
      //print(doc.head.children);
      //print(doc.body);
      expect(doc.body.children.length, 0);
      //print(document.nodes[0].toString());
      //print(document.documentElement.outerHtml);
    });

    test('head', () {
      Document doc = html.createDocument(title: 'test');
      expect(doc.head.innerHtml, '<meta charset="utf-8"><title>test</title>');

      doc = html.createDocument(title: 'test', charset: null);
      expect(doc.head.innerHtml, '<title>test</title>');
    });

    test('html', () {
      Document doc = html.createDocument(title: 'test');
      expect(doc.html.innerHtml,
          '<head><meta charset="utf-8"><title>test</title></head><body></body>');
    });

    test('createDocumentHtml', () {
      Document doc = html.createDocument(
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

    test('createDocumentHtml no fix', () {
      Document doc = html.createDocument(
          html: '<!DOCTYPE html><html><head></head><body></body></html>',
          noCharsetTitleFix: true);

      expect(doc.toString(),
          '<!DOCTYPE html><html><head></head><body></body></html>');
    });

    test('createDocumentHtml empty', () {
      Document doc = html.createDocument(html: '', noCharsetTitleFix: true);
      doc.fixMissing();
      expect(doc.toString(),
          '<!DOCTYPE html><html><head><meta charset="utf-8"><title></title></head><body></body></html>');
    });

    test('fix charset and title', () {
      Document doc = html.createDocument(html: '<!DOCTYPE html>');
      expect(doc.toString(),
          '<!DOCTYPE html><html><head><meta charset="utf-8"><title></title></head><body></body></html>');
      doc.fixMissing();
      expect(doc.toString(),
          '<!DOCTYPE html><html><head><meta charset="utf-8"><title></title></head><body></body></html>');
    });
  });
}
