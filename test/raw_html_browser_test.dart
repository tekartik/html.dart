@TestOn('browser')
library html_browser_test;

import 'package:tekartik_common_utils/env_utils.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

//import 'package:html5lib/dom.dart';
//import 'package:tekartik_common/test_utils.dart';

void main() {
  group('browser', () {
    test('current document', () {
      /*
      print(document.nodes[0].toString());
      print(document.documentElement.outerHtml);
      */
    });

    test('node', () {
      final element = HTMLDivElement();
      final child = HTMLDivElement();
      element.append(child);
      expect(element.children.item(0), child);
      expect(element.children.item(0), element.firstChild);

      if (kDartIsWebWasm) {
        // !!!
        expect(element.children.item(0), isNot(same(child)));
        expect(element.children.item(0), isNot(same(element.firstChild)));
        expect(element.children.item(0), isNot(same(element.children.item(0))));
      } else {
        expect(element.children.item(0), same(child));
        expect(element.children.item(0), same(element.firstChild));
        expect(element.children.item(0), same(element.children.item(0)));
      }
    });

    test('element', () {
      var element = HTMLDivElement();
      expect('DIV', element.tagName);
      element.id = 'test';
      element.title = 'title';
      expect(element.classList.length, 0);
      element.classList
        ..add('class1')
        ..add('class2');
      expect(element.classList.length, 2);
      //element.tagName = 'kl';

      expect(element, element);
      //expect(element, new DivElement());
    });

    test('classes', () {
      var element = HTMLDivElement();
      expect(element.attributes.getNamedItem('class'), isNull);
      element.attributes
          .setNamedItem(document.createAttribute('class')..value = 'test');
      // This fails on firefox: https://github.com/dart-lang/sdk/issues/23604
      expect(element.outerHTML, '<div class="test"></div>');
    });

    test('document', () {
      //new HtmlHtmlElement();
      final doc = document.implementation.createHTMLDocument('');
      expect('<html><head><title></title></head><body></body></html>',
          doc.documentElement!.outerHTML);
      expect(doc.querySelector('head'), isNotNull);
      //doc.documentElement.nodes.insert(0, new HtmlDocument)
    });
    test('document title', () {
      //new HtmlHtmlElement();
      final doc = document.implementation.createHTMLDocument('title');
      expect(doc.title, 'title');
      expect('<html><head><title>title</title></head><body></body></html>',
          doc.documentElement!.outerHTML);
      //doc.documentElement.nodes.insert(0, new HtmlDocument)
      expect(1, 1);
    });

    test('html', () {
      // not working on firefox windows
      // ignore: unsafe_html
      final element = HTMLDivElement();
      expect(element.outerHTML, '<div></div>');
    });
  });
}
