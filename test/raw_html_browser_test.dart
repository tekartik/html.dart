@TestOn('browser')
library;

import 'dart:js_interop';

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

    test('div node', () {
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

    test('text node', () {
      final element = HTMLDivElement();
      element.append(Text(' '));
      expect(element.nodeType, Node.ELEMENT_NODE);
      expect(element.nodeValue, isNull);
      expect(element.nodeName, 'DIV');
      expect(element.childNodes.length, 1);
      expect(element.children.length, 0);
      var firstNode = element.childNodes.item(0)!;

      expect(firstNode.textContent, ' ');
      expect(firstNode.nodeType, Node.TEXT_NODE);
      expect(firstNode.nodeValue, ' ');
      expect(firstNode.nodeName, '#text');

      /// Indeed not possible
      expect(firstNode, isA<Text>());

      /// ! So we should not relay on type
      expect(firstNode, isA<Element>());

      /// JS: JSObject
      /// WASM: JS Value
      // print(firstNode.runtimeType);
    });

    test('children node', () {
      final element = HTMLDivElement()..append(HTMLDivElement());
      expect(element.children.length, 1);
      var child = element.children.item(0)!;
      element.removeChild(child);
      expect(element.children.length, 0);
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
      expect(
          (element.outerHTML as JSString).toDart, '<div class="test"></div>');
    });

    test('document', () {
      //new HtmlHtmlElement();
      final doc = document.implementation.createHTMLDocument('');
      expect((doc.documentElement!.outerHTML as JSString).toDart,
          '<html><head><title></title></head><body></body></html>');
      expect(doc.querySelector('head'), isNotNull);
      //doc.documentElement.nodes.insert(0, new HtmlDocument)
    });
    test('document title', () {
      //new HtmlHtmlElement();
      final doc = document.implementation.createHTMLDocument('title');
      expect(doc.title, 'title');
      expect((doc.documentElement!.outerHTML as JSString).toDart,
          '<html><head><title>title</title></head><body></body></html>');
      //doc.documentElement.nodes.insert(0, new HtmlDocument)
      expect(1, 1);
    });

    test('html', () {
      // not working on firefox windows
      // ignore: unsafe_html
      final element = HTMLDivElement();
      expect((element.outerHTML as JSString).toDart, '<div></div>');
    });
  });
}
