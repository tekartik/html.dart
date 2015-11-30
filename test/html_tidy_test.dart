library document_test;

import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/html_html5lib.dart';
import 'package:tekartik_html/util/html_tidy.dart';
import 'package:dev_test/test.dart';

main() {
  HtmlProvider html = htmlProviderHtml5Lib;
  test_main(html);
}

test_main(HtmlProvider html) {
  group('tidy', () {
    group('document', () {
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
    });

    group('indent', () {
      test('sub_div_element', () {
        Element element =
            html.createElementHtml("<div><div><div></div></div></div>");
        expect(htmlTidyElement(element, new HtmlTidyOption()..indent = ' '),
            ['<div>', ' <div>', '  <div></div>', ' </div>', '</div>']);
      });
    });
    group('element', () {
      test('title_element', () {
        Element element = html.createElementHtml("<title>some  text</title>");
        expect(htmlTidyElement(element), ['<title>some  text</title>']);
      });

      test('void_input_element', () {
        Element element = html.createElementTag('input');
        expect(element.outerHtml, "<input>");
        expect(htmlTidyElement(element), ['<input>']);
      });

      test('span_element', () {
        Element element = html.createElementHtml("<span>test</span>");
        expect(htmlTidyElement(element), ['<span>test</span>']);
      });

      test('paragraph_long', () {
        Element element = html.createElementHtml(
            '<p>0123456789 012345678 012345678910 0123456 789 12345</p>');
        //expect(htmlTidyElement(element), ['<input>']);
        //print(element.outerHtml);
        expect(
            htmlTidyElement(element, new HtmlTidyOption()..contentLength = 10),
            [
          '<p>',
          '\t0123456789',
          '\t012345678',
          '\t012345678910',
          '\t0123456',
          '\t789 12345',
          '</p>'
        ]);
      });

      test('paragraph', () {
        Element element = html.createElementTag('p');
        expect(htmlTidyElement(element), ['<p></p>']);
      });

      test('div_element', () {
        Element element = html.createElementHtml("<div>some  text</div>");
        expect(htmlTidyElement(element), ['<div>', '\tsome text', '</div>']);
      });

      test('sub_div_element', () {
        Element element = html.createElementHtml("<div><div></div></div>");
        expect(htmlTidyElement(element), ['<div>', '\t<div></div>', '</div>']);
      });

      test('sub_sub_div_element', () {
        Element element =
            html.createElementHtml("<div><div><div></div></div></div>");
        expect(htmlTidyElement(element),
            ['<div>', '\t<div>', '\t\t<div></div>', '\t</div>', '</div>']);
      });

      test('text_node', () {
        Element element = html.createElementHtml("<div>some text</div>");
        expect(htmlTidyElement(element), ['<div>', '\tsome text', '</div>']);
        element = html.createElementHtml("<div>some\ntext</div>");
        expect(htmlTidyElement(element), ['<div>', '\tsome text', '</div>']);
        /*
      expect(doc.toString(),
          '<!DOCTYPE html><html><head><meta charset="utf-8"><title>test</title></head><body></body></html>');
      //print(doc.head.children);
      //print(doc.body);
      expect(doc.body.children.length, 0);
      */
        //print(document.nodes[0].toString());
        //print(document.documentElement.outerHtml);
      });

      /*
    test('title', () {
      Document doc = html.createDocument(title: 'test');
      expect(doc.title, 'test');
      doc.title = 'update';
      expect(doc.title, 'update');
    });

    test('wrap', () {
      Document document = html.createDocument(title: 'test');

      dynamic _documentImpl = html.unwrapDocument(document);

      document = html.wrapDocument(_documentImpl);
      expect(document.title, 'test');
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
    */
    });
  });
}
