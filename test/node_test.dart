library;

import 'package:tekartik_html/html_html5lib.dart';
import 'package:test/test.dart';

void main() {
  final html = htmlProviderHtml5Lib;
  nodeTestGroup(html);
}

void nodeTestGroup(HtmlProvider html) {
  group('node', () {
    test('compat', () {
      // ignore: deprecated_member_use_from_same_package
      expect(Node.testNode, Node.textNode);
    });
    test('text', () {
      final element = html.createElementHtml('<p>hello</p>');
      expect(element.childNodes.length, 1);
      final node = element.childNodes.first;
      expect(node.nodeType, Node.textNode);
      expect(node.nodeValue, 'hello');
    });
    test('text node', () {
      final element = html.createElementHtml(' <div></div>');
      expect(element.nodeType, Node.elementNode);
      expect(element.textContent, '');
      expect(element.nodeValue, isNull);
      element.append(html.createTextNode(' '));
      expect(element.childNodes.length, 1);
      expect(element.children.length, 0);
      var firstNode = element.childNodes.first;
      expect(firstNode.textContent, ' ');
      expect(firstNode.nodeType, Node.textNode);
      expect(firstNode.nodeValue, ' ');
      expect(firstNode, isA<Text>());
      expect((firstNode as Text).text, ' ');
    });
    test('remove node', () {
      var element = html.createElementHtml('<div><p>hello</p></div>');
      expect(element.childNodes.length, 1);
      element.children.last.remove();
      expect(element.childNodes.length, 0);
    });
    test('not remove node', () {
      var element = html.createElementHtml('<div><p>hello</p></div>');
      expect(element.childNodes.length, 1);
      expect(() => element.childNodes.removeAt(0), throwsUnsupportedError);
      expect(element.childNodes.length, 1);
    });
    test('children node', () {
      final element = html.createElementHtml('<div><p>child</p></div>');
      expect(element.children.length, 1);
      element.children.removeAt(0);
      expect(element.children.length, 0);
    });
  });
}
