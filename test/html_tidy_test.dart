library;

import 'package:tekartik_html/html_html5lib.dart';
import 'package:tekartik_html/util/html_tidy.dart';
import 'package:test/test.dart';

void main() {
  final html = htmlProviderHtml5Lib;
  testMain(html);
}

void testMain(HtmlProvider html) {
  group('tidy_element', () {
    group('indent', () {
      test('sub_div_element', () {
        final element =
            html.createElementHtml('<div><div><div></div></div></div>');
        expect(htmlTidyElement(element, HtmlTidyOption()..indent = ' '),
            ['<div>', ' <div>', '  <div></div>', ' </div>', '</div>']);
      });
    });
    group('element', () {
      test('style_element', () {
        final element =
            html.createElementHtml('<style>body {\n\tmargin: 0;\n}</style>');
        //print(element.outerHtml);
        expect(htmlTidyElement(element),
            ['<style>', '\tbody {', '\t\tmargin: 0;', '\t}', '</style>']);
        html.createElementHtml('<style>body {\r\tmargin: 0;\r}</style>');
        expect(htmlTidyElement(element),
            ['<style>', '\tbody {', '\t\tmargin: 0;', '\t}', '</style>']);
      });
      test('style_element_single_line', () {
        // from amp
        final element =
            html.createElementHtml('<style>body {opacity: 0}</style>');
        //print(element.outerHtml);
        expect(htmlTidyElement(element), ['<style>body {opacity: 0}</style>']);
      });

      test('style_element_one_line feed', () {
        // from amp
        final element = html.createElementHtml('<style>\n</style>');
        //print(element.outerHtml);
        expect(htmlTidyElement(element), ['<style>', '</style>']);
      });
      test('title_element', () {
        final element = html.createElementHtml('<title>some  text</title>');
        expect(htmlTidyElement(element), ['<title>some  text</title>']);
      });

      test('void_input_element', () {
        final element = html.createElementTag('input');
        expect(element.outerHtml, '<input>');
        expect(htmlTidyElement(element), ['<input>']);
      });

      test('span_element', () {
        final element = html.createElementHtml('<span>test</span>');
        expect(htmlTidyElement(element), ['<span>test</span>']);
      });

      test('paragraph_long', () {
        final element = html.createElementHtml(
            '<p>0123456789 012345678 012345678910 0123456 789 12345\n</p>');
        //expect(htmlTidyElement(element), ['<input>']);
        //print(element.outerHtml);
        expect(htmlTidyElement(element, HtmlTidyOption()..contentLength = 10), [
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
        final element = html.createElementTag('p');
        expect(htmlTidyElement(element), ['<p></p>']);
      });

      test('div_element', () {
        final element = html.createElementHtml('<div>some  text\r</div>');
        expect(htmlTidyElement(element), ['<div>', '\tsome text', '</div>']);
      });

      test('sub_div_element', () {
        final element = html.createElementHtml('<div><div></div></div>');
        expect(htmlTidyElement(element), ['<div>', '\t<div></div>', '</div>']);
      });

      test('sub_sub_div_element', () {
        final element =
            html.createElementHtml('<div><div><div></div></div></div>');
        expect(htmlTidyElement(element),
            ['<div>', '\t<div>', '\t\t<div></div>', '\t</div>', '</div>']);
      });

      test('text_node', () {
        var element = html.createElementHtml('<div>some text</div>');
        expect(htmlTidyElement(element), ['<div>some text</div>']);
        element = html.createElementHtml('<div>some\ntext</div>');
        expect(htmlTidyElement(element), ['<div>', '\tsome text', '</div>']);
      });

      test('anchor_with_inner_element', () {
        final element = html.createElementHtml('<a><img/></a>');
        //print(element.outerHtml);
        expect(htmlTidyElement(element), ['<a>', '\t<img>', '</a>']);
      });
    });
  });
}
