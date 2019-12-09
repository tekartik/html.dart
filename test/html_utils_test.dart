library tekartik_html.html_utils_test;

import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/html_html5lib.dart';
import 'package:tekartik_html/html_utils.dart';
import 'package:tekartik_html/tag.dart';
import 'package:dev_test/test.dart';

void main() {
  final html = htmlProviderHtml5Lib;
  testMain(html);
}

void testMain(HtmlProvider html) {
  group('html_utils', () {
    test('findFirstAncestorWithId', () {
      final element = html.createElementTag(tagDiv)..id = 'div1';
      final innerElement = html.createElementTag(tagDiv)..id = 'div2';
      final subInnerElement = html.createElementTag(tagDiv)..id = 'div3';
      innerElement.append(subInnerElement);
      element.append(innerElement);
      expect(findFirstAncestorWithId(subInnerElement, 'div2'), innerElement);
      expect(findFirstAncestorWithId(subInnerElement, 'div1'), element);
      expect(findFirstAncestorWithId(subInnerElement, 'div3'), isNull);
      expect(findFirstAncestorWithId(subInnerElement, 'div3', true),
          subInnerElement);
    });

    test('findFirstAncestorWithClass', () {
      final element = html.createElementTag(tagDiv)..classes.add('class1');
      final innerElement = html.createElementTag(tagDiv)..classes.add('class2');
      final subInnerElement = html.createElementTag(tagDiv)
        ..classes.add('class3');
      innerElement.append(subInnerElement);
      element.append(innerElement);
      expect(
          findFirstAncestorWithClass(subInnerElement, 'class2'), innerElement);
      expect(findFirstAncestorWithClass(subInnerElement, 'class1'), element);
      expect(findFirstAncestorWithClass(subInnerElement, 'class3'), isNull);
      expect(findFirstAncestorWithClass(subInnerElement, 'class3', true),
          subInnerElement);
    });
  });
}
