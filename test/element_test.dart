library element_test;

import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/html_html5lib.dart';
import 'package:tekartik_html/tag.dart';
import 'package:dev_test/test.dart';

main() {
  HtmlProvider html = htmlProviderHtml5Lib;
  test_main(html);
}

test_main(HtmlProvider html) {
  group('element', () {
    test('createElementTag', () {
      Element element = html.createElementTag(DIV);
      expect(element.tagName, DIV);
      expect(element.id, isEmpty);
    });

    test('wrap', () {
      Element element = html.createElementTag(DIV);
      dynamic _element = html.unwrapElement(element);
      element = html.wrapElement(_element);
      expect(element.tagName, DIV);
    });

    test('toString', () {
      Element element = html.createElementTag(DIV);
      dynamic _element = html.unwrapElement(element);
      expect(_element.toString(), element.toString());
    });

    test('hashCode', () {
      Element element = html.createElementTag(DIV);
      dynamic _element = html.unwrapElement(element);
      expect(_element.hashCode, element.hashCode);
    });

    test('equals', () {
      Element element1 = html.createElementTag(DIV);
      Element element2 = html.createElementTag(DIV);
      dynamic _element1 = html.unwrapElement(element1);
      dynamic _element1bis = html.unwrapElement(element1);
      dynamic _element2 = html.unwrapElement(element2);
      Element element1bis = html.wrapElement(_element1bis);
      expect(identical(_element1, _element1bis), isTrue);
      expect(_element1, isNot(_element2));
      expect(element1, isNot(element2));
      expect(element1, element1bis); // same
      expect(identical(element1, element1bis), isFalse); // but not identical!
    });

    test('id', () {
      Element element = html.createElementTag(DIV);
      element.id = 'div1';
      expect(element.id, 'div1');
    });

    test('attributes', () {
      Element element = html.createElementTag(DIV)..id = 'div1';
      expect(element.attributes['id'], 'div1');
    });

    test('text', () {
      Element element = html.createElementTag(DIV)..text = 'content';
      expect(element.text, 'content');
    });

    test('node', () {
      Element element = html.createElementTag(DIV);
      Element child = html.createElementTag(DIV);
      element.append(child);
      //expect(element.children[0], same(element.firstChild));
    });

    test('createElementHtml', () {
      Element element = html.createElementHtml('<Div id="test">inner</div>');
      expect(element.tagName, DIV);
      expect(element.id, 'test');
      expect(element.innerHtml, 'inner');
      expect(element.outerHtml, '<div id="test">inner</div>');
    });

    /*
    test('createElementHtmlHtml', () {
      Element element = html.createElementHtml('<html></html>');
      expect(element.tagName, HTML);
      expect(element.id, 'test');
      expect(element.innerHtml, '');
      expect(element.outerHtml, '<html></html>');
    });
    */

    test('custom tag attributes bis', () {
      if (html.name != PROVIDER_BROWSER_NAME) {
        Element element =
            html.createElementHtml('<include src="test"></include>');
        expect(element.tagName, 'include');
        expect(element.attributes['src'], 'test');
        expect(element.innerHtml, '');
        expect(element.outerHtml, '<include src="test"></include>');

        element = html.createElementHtml('<include src="test"/>');
        expect(element.tagName, 'include');
        expect(element.attributes['src'], 'test');
        expect(element.innerHtml, '');
        expect(element.outerHtml, '<include src="test"></include>');
      }
    });

    test('dataset', () {
      if (html.name != PROVIDER_BROWSER_NAME) {
        Element element = html.createElementHtml('<div data-src="test"></div>');
        DataSet dataset = element.dataset;
        //print(dataset.keys);
        expect(dataset.keys.first, 'src');

        expect(dataset.remove('src'), isTrue);
        expect(dataset.keys.length, 0);
      }
    });
    // });

    test('createDocumentHtml', () {
      //      Element element = html.createElementHtml('<!DOCTYPE html><html><head></head><body></body></html>');
      //      expect(element.tagName, DIV);
      //      expect(element.id, 'test');
      //      expect(element.innerHtml, 'inner');
      //      expect(element.outerHtml, '<div id="test">inner</div>');
    });

    test('children', () {
      Element element = html.createElementTag(DIV);
      Element child = html.createElementTag(SPAN);
      element.children.add(child);
      expect(element.children.length, 1);
      expect(element.innerHtml, '<span></span>');
      expect(element.outerHtml, '<div><span></span></div>');
      int count = 0;
      for (Element someChild in element.children) {
        count++;
        expect(someChild.outerHtml, '<span></span>');
      }
      expect(count, 1);

      Element child2 = html.createElementTag(P);
      element.children.add(child2);
      expect(element.children.length, 2);
      expect(element.innerHtml, '<span></span><p></p>');
      expect(element.outerHtml, '<div><span></span><p></p></div>');

      // testing iterator
      count = 0;
      for (Element someChild in element.children) {
        count++;
        if (count == 1) {
          expect(someChild.outerHtml, '<span></span>');
        } else {
          expect(someChild.outerHtml, '<p></p>');
        }
      }

      expect(count, 2);
    });

    test('querySelector', () {
      Element element = html.createElementTag(DIV)..id = 'div1';
      Element child = html.createElementTag(SPAN)..id = 'span1';
      element.children.add(child);

      expect(element.querySelector('dummy'), isNull);
      expect(element.querySelectorAll('dummy').length, 0);

      expect(element.querySelector(SPAN), child);
      expect(element.querySelectorAll(SPAN).length, 1);

      //expect(element.querySelector('span#dummy'), isNull);
      //print(element.outerHtml);
      //expect(element.querySelector('span#span1'), child);
    });

    test('simple query', () {
      Element element = html.createElementTag(DIV)..id = 'div1';
      Element child = html.createElementTag(SPAN)
        ..id = 'span1'
        ..classes.add('class1')
        ..attributes['attr1'] = 'attr_value1';
      element.children.add(child);

      // not supported expect(element.query(), child);

      expect(element.query(byTag: 'dummy'), isNull);
      expect(element.query(byTag: SPAN), child);
      expect(element.query(byTag: SPAN, byId: 'dummy'), isNull);
      expect(element.query(byTag: SPAN, byClass: 'dummy'), isNull);
      expect(element.query(byTag: SPAN, byAttributes: 'dummy'), isNull);

      //expect(element.querySelectorAll('dummy').length, 0);

      //expect(element.querySelectorAll(SPAN).length, 1);

      expect(element.query(byId: 'dummy'), isNull);
      expect(element.query(byId: 'span1'), child);
      expect(element.query(byId: 'span1', byTag: 'dummy'), isNull);
      expect(element.query(byId: 'span1', byClass: 'dummy'), isNull);
      expect(element.query(byId: 'span1', byTag: SPAN), child);

      expect(element.query(byClass: 'dummy'), isNull);
      expect(element.query(byClass: 'class1'), child);
      expect(element.query(byClass: 'class1', byTag: 'dummy'), isNull);
      expect(element.query(byClass: 'class1', byId: 'dummy'), isNull);

      expect(element.query(byClass: 'class1', byId: 'span1'), child);
      expect(element.query(byClass: 'class1', byTag: SPAN), child);

      expect(
          element.query(byClass: 'class1', byTag: SPAN, byId: 'span1'), child);
      expect(
          element.query(byClass: 'class1', byTag: SPAN, byId: 'dummy'), isNull);
      expect(element.query(byClass: 'class1', byId: 'span1', byTag: 'dummy'),
          isNull);

      expect(
          element.query(
              byClass: 'class1',
              byTag: SPAN,
              byId: 'span1',
              byAttributes: 'attr1'),
          child);
      expect(
          element.query(
              byClass: 'class1',
              byTag: SPAN,
              byId: 'span1',
              byAttributes: 'dummy'),
          isNull);

      expect(element.queryAll(byClass: 'class1', byTag: SPAN, byId: 'span1')[0],
          child);
      //expect(element.queryAll()[0], child);

      expect(
          element
              .queryAll(byClass: 'class1', byTag: SPAN, byId: 'dummy')
              .length,
          0);

      expect(element.query(byAttributes: 'dummy'), isNull);
      expect(element.query(byAttributes: 'attr1'), child);
      expect(element.queryAll(byAttributes: 'attr1')[0], child);
      expect(element.query(byTag: SPAN, byAttributes: 'attr1'), child);
    });

    test('sub query', () {
      Element element = html.createElementTag(DIV);
      Element child = html.createElementTag(DIV)
        ..id = 'div1'
        ..classes.add('class1')
        ..attributes['attr1'] = 'attr_value_child';
      Element child2 = html.createElementTag(DIV)
        ..id = 'div2'
        ..classes.add('class2')
        ..attributes['attr2'] = 'attr_value_child2';

      Element subchild = html.createElementTag(SPAN)
        ..id = 'span1'
        ..classes.add('class1')
        ..attributes['attr1'] = 'attr_value_subchild';

      child.children.add(subchild);
      element.children.add(child);
      element.children.add(child2);

      //expect(element.query(), child);

      expect(element.query(byClass: 'class1'), child);
      expect(element.queryAll(byClass: 'class1').length, 2);
      expect(element.queryAll(byClass: 'class1')[0], child);
      expect(element.queryAll(byClass: 'class1')[1], subchild);
      expect(element.query(byAttributes: 'attr1'), child);
      //print(element.innerHtml);
      expect(element.query(byAttributes: 'attr2'), child2);
      ElementList list = element.queryAll(byAttributes: 'attr1');
      expect(list.length, 2);
      expect(list[0], child);
      expect(list[1], subchild);

      expect(child.query(byAttributes: 'attr1'), subchild);

      // important test
      expect(child.query(byAttributes: 'attr1'), subchild);
    });

    test('class', () {
      Element element = html.createElementTag(DIV);
      expect(element.classes.contains('test'), isFalse);
      expect(element.classes.add('test'), isTrue);
      expect(element.classes.add('test'), isFalse);
      expect(element.outerHtml, '<div class="test"></div>');
      element = html.createElementHtml('<div class="test"></div>');
      expect(element.classes.contains('test'), isTrue);
      expect(element.classes.add('test'), isFalse);
      expect(element.classes.remove('test'), isTrue);
      expect(element.classes.remove('test'), isFalse);
      expect(element.outerHtml, '<div class=""></div>');
    });

    test('createElementHtmlWithValidation', () {});
    test('createElementHtmlNoValidation', () {
      /*
      String fullFlickr = '''
<a href=\"https://www.flickr.com/photos/62771079@N04/15282515877\" title=\"keep_on_screenshot_1280x800 by alexroux77, on Flickr\"><img src=\"https://farm3.staticflickr.com/2947/15282515877_842648d61d_s.jpg\" width=\"75\" height=\"75\" alt=\"keep_on_screenshot_1280x800\"></a>
          ''';
          */

      String img = '''
<img src=\"https://farm3.staticflickr.com/2947/15282515877_842648d61d_s.jpg\" width=\"75\" height=\"75\" alt=\"keep_on_screenshot_1280x800\">
          ''';
      Element element = html.createElementHtml(img, noValidate: true);

//<a href="https://www.flickr.com/photos/62771079@N04/15282515877" title="keep_on_screenshot_1280x800 by alexroux77, on Flickr"><img src="https://farm3.staticflickr.com/2947/15282515877_842648d61d_s.jpg" width="75" height="75" alt="keep_on_screenshot_1280x800"></a>');

      //devPrint("${element} ${new Map.from(element.attributes)}");
      expect(element.attributes['src'],
          "https://farm3.staticflickr.com/2947/15282515877_842648d61d_s.jpg");
//         expect(element.tagName, DIV);
//         expect(element.id, 'test');
//         expect(element.innerHtml, 'inner');
//         expect(element.outerHtml, '<div id="test">inner</div>');
    });
  });
}
