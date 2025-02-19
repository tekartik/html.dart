library;

import 'package:html/dom.dart';
import 'package:test/test.dart';

void main() {
  group('html5lib sdk', () {
    test('document', () {
      final doc = Document();
      expect(doc.outerHtml, '');
      Node docType = DocumentType('html', null, null);
      doc.nodes.add(docType);
      expect(doc.outerHtml, '<!DOCTYPE html>');
    });

    test('document', () {
      /*Document doc = */ Document();
    });

    test('document.html', () {
      final doc = Document.html('');
      expect(doc.outerHtml, '<html><head></head><body></body></html>');
      Node docType = DocumentType('html', null, null);
      doc.nodes.insert(0, docType);
      expect(doc.outerHtml,
          '<!DOCTYPE html><html><head></head><body></body></html>');
    });

    test('div node', () {
      final element = Element.tag('div');
      final child = Element.tag('div');
      element.append(child);
      expect(element.children[0], same(element.firstChild));
      expect(element.children.length, 1);
      expect(element.hasChildNodes(), isTrue);
      expect(element.nodes.length, 1);
    });
    test('text node', () {
      final element = Element.html(' <div></div>');
      expect(element.nodeType, Node.ELEMENT_NODE);
      expect(element.text, '');
      element.append(Text(' '));
      expect(element.nodes.length, 1);
      expect(element.children.length, 0);
      var firstNode = element.nodes.first;
      expect(firstNode.text, ' ');
      expect(firstNode.nodeType, Node.TEXT_NODE);
      expect(firstNode, isA<Text>());
      expect(firstNode, isNot(isA<Element>()));
    });

    test('element', () {
      final element = Element.tag('div');
      expect('div', element.localName);
      element.id = 'test';
      //element.title = 'title';
      //element.classes.addAll(['class1', 'class2']);
      //element.tagName = 'kl';

      //print(element.toString());
      //print(element.outerHtml);
    });
    test('classes', () {
      final element = Element.tag('div');
      expect(element.attributes['class'], isNull);
//          element.attributes['class'] = 'test';
//          expect(element.outerHtml, '<div class="test"></div>');
    });

    void dumpNode(Node node) {
      //print('${node.runtimeType}: ${node}');
      for (var innerNode in node.nodes) {
        dumpNode(innerNode);
      }
    }

    test('document.html title', () {
      final doc =
          Document.html('<html><head><title>title</title></head></html>');
      expect(doc.querySelector('head'), isNotNull);
      dumpNode(doc);

      //expect(doc.outerHtml, '<html><head></head><body></body></html>');
      //Node docType = new DocumentType('html', null, null);
      //doc.nodes.insert(0, docType);
      //expect(doc.outerHtml, '<!DOCTYPE html><html><head></head><body></body></html>');
    });
  });
}
