library element_test;

import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/html_html5lib.dart';
import 'package:dev_test/test.dart';

void main() {
  HtmlProvider html = htmlProviderHtml5Lib;
  testMain(html);
}

void testMain(HtmlProvider html) {
  group('node', () {
    test('text', () {
      Element element = html.createElementHtml('<p>hello</p>');
      expect(element.childNodes.length, 1);
      Node node = element.childNodes.first;
      expect(node.nodeType, Node.TEXT_NODE);
      expect(node.nodeValue, "hello");
    });
  });
}
