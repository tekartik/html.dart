library;

import 'package:tekartik_html/html_html5lib.dart';
import 'package:test/test.dart';

void main() {
  final html = htmlProviderHtml5Lib;
  nodeTestGroup(html);
}

void nodeTestGroup(final HtmlProvider html) {
  group('node', () {
    test('compat', () {
      // ignore: deprecated_member_use_from_same_package
      expect(Node.testNode, Node.textNode);
    });
    test('wrap text', () {
      var text = html.createTextNode('hello');

      expect(html.wrapNode(html.unwrapNode(text)), text);
    });
    test('wrap element', () {
      var div = html.createElementTag('div');

      expect(html.wrapNode(html.unwrapNode(div)), div);
    });
    test('child append/remove', () {
      var element = html.createElementTag('div');
      var textNode = html.createTextNode('hello');
      expect(textNode.parentNode, isNull);
      expect(element.appendChild(textNode), textNode);
      expect(textNode.parentNode, element);
      expect(element.childNodes.length, 1);
      expect(element.removeChild(textNode), textNode);
      expect(element.childNodes.length, 0);

      expect(() => element.removeChild(textNode), throwsA(isA<StateError>()));
    });
    test('appendChildren', () {
      var element = html.createElementTag('div');
      element.appendNodesHtml('<p>t1</p><p>t2</p>');
      expect(element.outerHtml, '<div><p>t1</p><p>t2</p></div>');
      expect(element.children.length, 2);
    });
    test('removed parent', () {
      Element div() =>
          html.createElementHtml('<div><p></p><a></a><b></b></div>');
      var element = div();
      var child = element.children[0];
      element.removeChild(child);
      expect(child.parentNode, isNull);
      expect(child.parent, isNull);
      element = div();
      child = element.children[0]..remove();
      expect(child.parentNode, isNull);
      element = div();
      child = element.children[0];
      expect(element.children.remove(child), isTrue);
      expect(child.parentNode, isNull);
      element = div();
      child = element.children.removeAt(0)!;
      expect(child.parentNode, isNull);
      expect(element.outerHtml, '<div><a></a><b></b></div>');
    });
    test('child not a child', () {
      var element = html.createElementTag('div');
      var other = html.createElementHtml('<section><a></a></section>');
      var otherChild = other.children[0];
      expect(
        () => element.insertBefore(html.createElementTag('p'), otherChild),
        throwsStateError,
      );
      expect(
        () => element.replaceChild(html.createElementTag('p'), otherChild),
        throwsStateError,
      );
      expect(element.outerHtml, '<div></div>');
      expect(other.outerHtml, '<section><a></a></section>');
    });
    test('child replace', () {
      var element = html.createElementTag('div');
      var textNode = html.createTextNode('hello');
      var newTextNode = html.createTextNode('bye');
      expect(element.appendChild(textNode), textNode);
      expect(element.childNodes.length, 1);
      expect(element.replaceChild(newTextNode, textNode), newTextNode);
      expect(element.childNodes.first, newTextNode);
    });
    test('node replaceWith', () {
      var element = html.createElementTag('div');
      var textNode = html.createTextNode('hello');
      var newTextNode = html.createTextNode('bye');
      expect(element.appendChild(textNode), textNode);
      textNode.replaceWith(newTextNode);

      expect(element.childNodes.first, newTextNode);
    });
    test('child insert before', () {
      var element = html.createElementTag('div');
      var textNode = html.createTextNode('hello');
      var pNode = html.createElementTag('p');
      element.appendChild(textNode);
      element.insertBefore(pNode, textNode);

      expect(element.childNodes, [pNode, textNode]);
    });
    test('child multi op', () {
      var element = html.createElementTag('div');
      var textNode = html.createTextNode('hello');
      var pNode = html.createElementTag('p');
      element.appendChild(textNode);
      element.appendChild(pNode);
      element.removeChild(textNode);
      expect(element.childNodes, [pNode]);
      element.removeChild(pNode);
      expect(element.childNodes.length, 0);
    });
    test('textNode', () {
      final text = html.createTextNode('hello');
      expect(text.htmlProvider, html);
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
