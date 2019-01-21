library html5lib_test;

import 'package:html/dom.dart';
import 'package:test/test.dart';

void main() {
  group('html5lib sdk', () {
    test('document', () {
      Document doc = Document();
      expect(doc.outerHtml, '');
      Node docType = DocumentType('html', null, null);
      doc.nodes.add(docType);
      expect(doc.outerHtml, '<!DOCTYPE html>');
    });

    test('document', () {
      /*Document doc = */ Document();
    });

    test('document.html', () {
      Document doc = Document.html('');
      expect(doc.outerHtml, '<html><head></head><body></body></html>');
      Node docType = DocumentType('html', null, null);
      doc.nodes.insert(0, docType);
      expect(doc.outerHtml,
          '<!DOCTYPE html><html><head></head><body></body></html>');
    });

    test('node', () {
      Element element = Element.tag('div');
      Element child = Element.tag('div');
      element.append(child);
      expect(element.children[0], same(element.firstChild));
    });

    test('element', () {
      Element element = Element.tag('div');
      expect('div', element.localName);
      element.id = 'test';
      //element.title = 'title';
      //element.classes.addAll(['class1', 'class2']);
      //element.tagName = 'kl';

      //print(element.toString());
      //print(element.outerHtml);
    });
    test('classes', () {
      Element element = Element.tag('div');
      expect(element.attributes['class'], isNull);
//          element.attributes['class'] = 'test';
//          expect(element.outerHtml, '<div class="test"></div>');
    });

    void dumpNode(Node node) {
      //print('${node.runtimeType}: ${node}');
      node.nodes.forEach((Node _node) {
        dumpNode(_node);
      });
    }

    test('document.html title', () {
      Document doc =
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
