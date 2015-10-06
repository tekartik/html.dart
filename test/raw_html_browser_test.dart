@TestOn("browser")
library html_browser_test;

import 'package:dev_test/test.dart';
import 'dart:html';
//import 'package:html5lib/dom.dart';
//import 'package:tekartik_common/test_utils.dart';

main() {
  group('browser', () {
    test('current document', () {
      /*
      print(document.nodes[0].toString());
      print(document.documentElement.outerHtml);
      */
    });

    test('node', () {
      Element element = new Element.tag('div');
      Element child = new Element.tag('div');
      element.append(child);
      expect(element.children[0], same(element.firstChild));
    });

    test('element', () {
      Element element = new DivElement();
      expect('DIV', element.tagName);
      element.id = 'test';
      element.title = 'title';
      expect(element.classes.length, 0);
      element.classes.addAll(['class1', 'class2']);
      expect(element.classes.length, 2);
      //element.tagName = 'kl';

      expect(element, element);
      //expect(element, new DivElement());
    });

    test('classes', () {
      Element element = new DivElement();
      expect(element.attributes['class'], isNull);
      element.attributes['class'] = 'test';
      // This fails on firefox: https://github.com/dart-lang/sdk/issues/23604
      expect(element.outerHtml, '<div class="test"></div>');
    });

    test('document', () {
      //new HtmlHtmlElement();
      HtmlDocument doc = document.implementation.createHtmlDocument('');
      expect('<html><head><title></title></head><body></body></html>',
          doc.documentElement.outerHtml);
      expect(doc.querySelector('head'), isNotNull);
      //doc.documentElement.nodes.insert(0, new HtmlDocument)
    });
    test('document title', () {
      //new HtmlHtmlElement();
      HtmlDocument doc = document.implementation.createHtmlDocument('title');
      expect(doc.title, 'title');
      expect('<html><head><title>title</title></head><body></body></html>',
          doc.documentElement.outerHtml);
      //doc.documentElement.nodes.insert(0, new HtmlDocument)
      expect(1, 1);
    });
  });
}
