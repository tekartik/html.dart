library tekartik_html.html_utils_test;

import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/html_html5lib.dart';
import 'package:tekartik_html/html_utils.dart';
import 'package:tekartik_html/tag.dart';
import 'package:dev_test/test.dart';

main() {
  HtmlProvider html = htmlProviderHtml5Lib;
  test_main(html);
}

test_main(HtmlProvider html) {
  group('html_utils', () {
    test('findFirstAncestorWithId', () {
      Element element = html.createElementTag(DIV)..id = "div1";
      Element innerElement = html.createElementTag(DIV)..id = "div2";
      Element subInnerElement = html.createElementTag(DIV)..id = "div3";
      innerElement.append(subInnerElement);
      element.append(innerElement);
      expect(findFirstAncestorWithId(subInnerElement, "div2"), innerElement);
      expect(findFirstAncestorWithId(subInnerElement, "div1"), element);
      expect(findFirstAncestorWithId(subInnerElement, "div3"), isNull);
      expect(findFirstAncestorWithId(subInnerElement, "div3", true),
          subInnerElement);
    });

    test('findFirstAncestorWithClass', () {
      Element element = html.createElementTag(DIV)..classes.add("class1");
      Element innerElement = html.createElementTag(DIV)..classes.add("class2");
      Element subInnerElement = html.createElementTag(DIV)
        ..classes.add("class3");
      innerElement.append(subInnerElement);
      element.append(innerElement);
      expect(
          findFirstAncestorWithClass(subInnerElement, "class2"), innerElement);
      expect(findFirstAncestorWithClass(subInnerElement, "class1"), element);
      expect(findFirstAncestorWithClass(subInnerElement, "class3"), isNull);
      expect(findFirstAncestorWithClass(subInnerElement, "class3", true),
          subInnerElement);
    });
  });
}
