library;

import 'package:tekartik_html/html_html5lib.dart';
import 'package:tekartik_html/tag.dart';
import 'package:test/test.dart';

void main() {
  final html = htmlProviderHtml5Lib;
  testMain(html);
}

void testMain(HtmlProvider html) {
  final isBrowser = html.name == providerBrowserName;
  group('element', () {
    test('createElementTag', () {
      final element = html.createElementTag(tagDiv);
      expect(element.tagName, tagDiv);
      expect(element.id, isEmpty);
      expect(element.htmlProvider, html);
    });

    test('wrap', () {
      Element? element = html.createElementTag(tagDiv);
      var nativeElement = html.unwrapElement(element);
      element = html.wrapElement(nativeElement);
      expect(element.tagName, tagDiv);
    });

    test('toString', () {
      final element = html.createElementTag(tagDiv);
      dynamic nativeElement = html.unwrapElement(element);
      expect(nativeElement.toString(), element.toString());
    });

    test('hashCode', () {
      final element = html.createElementTag(tagDiv);
      dynamic nativeElement = html.unwrapElement(element);
      expect(nativeElement.hashCode, element.hashCode);
    });

    test('equals', () {
      final element1 = html.createElementTag(tagDiv);
      final element2 = html.createElementTag(tagDiv);
      var nativeElement1 = html.unwrapElement(element1);
      var nativeElement1bis = html.unwrapElement(element1);
      var nativeElement2 = html.unwrapElement(element2);
      final element1bis = html.wrapElement(nativeElement1bis);
      expect(identical(nativeElement1, nativeElement1bis), isTrue);
      expect(nativeElement1, isNot(nativeElement2));
      expect(element1, isNot(element2));
      expect(element1, element1bis); // same
      expect(identical(element1, element1bis), isFalse); // but not identical!
    });

    test('id', () {
      final element = html.createElementTag(tagDiv);
      element.id = 'div1';
      expect(element.id, 'div1');
    });

    test('attributes', () {
      final element = html.createElementTag(tagDiv)..id = 'div1';
      expect(element.attributes['id'], 'div1');
    });

    test('text', () {
      final element = html.createElementTag(tagDiv)..text = 'content';
      expect(element.text, 'content');
    });

    test('node', () {
      final element = html.createElementTag(tagDiv);
      final child = html.createElementTag(tagDiv);
      element.append(child);
      //expect(element.children[0], same(element.firstChild));
    });

    test('children', () {
      final element = html.createElementTag(tagDiv);
      final child1 = html.createElementTag(tagDiv);
      final child2 = html.createElementTag(tagP);
      final child3 = html.createElementTag(tagA);
      element.append(child1);
      element.append(child2);
      element.insertBefore(child3, child2);
      expect(element.children.length, 3);
      expect(element.children, [child1, child3, child2]);
      expect(element.removeChild(child3), child3);
      expect(element.children, [child1, child2]);
    });
    test('weird_tag', () {
      try {
        final element = html.createElementTag('?');
        expect(element.tagName, '?');
      } catch (_) {
        // fail in dom
      }

      //expect(element.children[0], same(element.firstChild));
    });
    test('html_weird_tag', () {
      try {
        html.createElementHtml('<? id="test"></?>');
        fail('should fail');
      } catch (_) {
        //print(_.runtimeType);
        //print(_);
      }
      //expect(element.tagName, '?');
      //expect(element.children[0], same(element.firstChild));
    });

    test('custom', () {
      final element = html.createElementHtml('''
      <div>
      <div class='--dtk-include' title='some/path/1'></div>
      <meta property='dtk-include' content='some/path/2' />
      </div>
      ''');
      //print(element);
      if (isBrowser) {
        expect(element.children.length, 1);
      } else {
        expect(element.children.length, 2);
      }
    });
    test('custom_no_validate', () {
      final element = html.createElementHtml(
          '<div><div class="--dtk-include" title="some/path/1"></div><meta property="dtk-include" content="some/path/2" /></div>',
          noValidate: true);
      //print(element.outerHtml.toString());
      expect(element.children.length, 2);
    });

    //solo_test('two_elements', () {
    //  Element element = html.createElementHtml('<div></div><div></div>');
    //  expect(element.children.length, 2);
    //});

    test('createElementHtml', () {
      final element = html.createElementHtml('<Div id="test">inner</div>');
      expect(element.tagName, tagDiv);
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
      if (!isBrowser) {
        var element = html.createElementHtml('<include src="test"></include>');
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

    test('attributes_no_content', () {
      var element = html.createElementHtml('<div ⚡></div>');
      // ok on standalone not browser
      if (element.outerHtml != '<div ⚡=" "></div>') {
        element = html.createElementHtml('<div ⚡></div>', noValidate: true);
        //
      }
      expect(element.outerHtml, '<div ⚡=""></div>');
      expect(element.attributes['⚡'], '');
      expect(element.attributes.length, 1);
    });

    test('dataset', () {
      if (html.name != providerBrowserName) {
        final element = html.createElementHtml('<div data-src="test"></div>');
        final dataset = element.dataset;
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
      //      expect(element.outerHtml, '<div id='test'>inner</div>');
    });

    test('children', () {
      final element = html.createElementTag(tagDiv);
      final child = html.createElementTag(tagSpan);
      element.children.add(child);
      expect(element.children.length, 1);
      expect(element.innerHtml, '<span></span>');
      expect(element.outerHtml, '<div><span></span></div>');
      var count = 0;
      for (final someChild in element.children) {
        count++;
        expect(someChild.outerHtml, '<span></span>');
      }
      expect(count, 1);

      final child2 = html.createElementTag(tagP);
      element.children.add(child2);
      expect(element.children.length, 2);
      expect(element.innerHtml, '<span></span><p></p>');
      expect(element.outerHtml, '<div><span></span><p></p></div>');

      // testing iterator
      count = 0;
      for (final someChild in element.children) {
        count++;
        if (count == 1) {
          expect(someChild.outerHtml, '<span></span>');
        } else {
          expect(someChild.outerHtml, '<p></p>');
        }
      }

      expect(count, 2);

      expect(element.children.length, 2);
      element.children.clear();
      expect(element.children.length, 0);
    });

    test('querySelector', () {
      final element = html.createElementTag(tagDiv)..id = 'div1';
      final child = html.createElementTag(tagSpan)..id = 'span1';
      element.children.add(child);

      expect(element.querySelector('dummy'), isNull);
      expect(element.querySelectorAll('dummy').length, 0);

      expect(element.querySelector(tagSpan), child);
      expect(element.querySelectorAll(tagSpan).length, 1);

      //expect(element.querySelector('span#dummy'), isNull);
      //print(element.outerHtml);
      //expect(element.querySelector('span#span1'), child);
    });

    test('simple query', () {
      final element = html.createElementTag(tagDiv)..id = 'div1';
      final child = html.createElementTag(tagSpan)
        ..id = 'span1'
        ..classes.add('class1')
        ..attributes['attr1'] = 'attr_value1';
      element.children.add(child);

      // not supported expect(element.query(), child);

      expect(element.query(byTag: 'dummy'), isNull);
      expect(element.query(byTag: tagSpan), child);
      expect(element.query(byTag: tagSpan, byId: 'dummy'), isNull);
      expect(element.query(byTag: tagSpan, byClass: 'dummy'), isNull);
      expect(element.query(byTag: tagSpan, byAttributes: 'dummy'), isNull);

      //expect(element.querySelectorAll('dummy').length, 0);

      //expect(element.querySelectorAll(SPAN).length, 1);

      expect(element.query(byId: 'dummy'), isNull);
      expect(element.query(byId: 'span1'), child);
      expect(element.query(byId: 'span1', byTag: 'dummy'), isNull);
      expect(element.query(byId: 'span1', byClass: 'dummy'), isNull);
      expect(element.query(byId: 'span1', byTag: tagSpan), child);

      expect(element.query(byClass: 'dummy'), isNull);
      expect(element.query(byClass: 'class1'), child);
      expect(element.query(byClass: 'class1', byTag: 'dummy'), isNull);
      expect(element.query(byClass: 'class1', byId: 'dummy'), isNull);

      expect(element.query(byClass: 'class1', byId: 'span1'), child);
      expect(element.query(byClass: 'class1', byTag: tagSpan), child);

      expect(element.query(byClass: 'class1', byTag: tagSpan, byId: 'span1'),
          child);
      expect(element.query(byClass: 'class1', byTag: tagSpan, byId: 'dummy'),
          isNull);
      expect(element.query(byClass: 'class1', byId: 'span1', byTag: 'dummy'),
          isNull);

      expect(
          element.query(
              byClass: 'class1',
              byTag: tagSpan,
              byId: 'span1',
              byAttributes: 'attr1'),
          child);
      expect(
          element.query(
              byClass: 'class1',
              byTag: tagSpan,
              byId: 'span1',
              byAttributes: 'dummy'),
          isNull);

      expect(
          element.queryAll(byClass: 'class1', byTag: tagSpan, byId: 'span1')[0],
          child);
      //expect(element.queryAll()[0], child);

      expect(
          element
              .queryAll(byClass: 'class1', byTag: tagSpan, byId: 'dummy')
              .length,
          0);

      expect(element.query(byAttributes: 'dummy'), isNull);
      expect(element.query(byAttributes: 'attr1'), child);
      expect(element.queryAll(byAttributes: 'attr1')[0], child);
      expect(element.query(byTag: tagSpan, byAttributes: 'attr1'), child);
    });

    test('sub query', () {
      final element = html.createElementTag(tagDiv);
      final child = html.createElementTag(tagDiv)
        ..id = 'div1'
        ..classes.add('class1')
        ..attributes['attr1'] = 'attr_value_child';
      final child2 = html.createElementTag(tagDiv)
        ..id = 'div2'
        ..classes.add('class2')
        ..attributes['attr2'] = 'attr_value_child2';

      final subchild = html.createElementTag(tagSpan)
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
      final list = element.queryAll(byAttributes: 'attr1');
      expect(list.length, 2);
      expect(list[0], child);
      expect(list[1], subchild);

      expect(child.query(byAttributes: 'attr1'), subchild);

      // important test
      expect(child.query(byAttributes: 'attr1'), subchild);
    });

    test('class', () {
      var element = html.createElementTag(tagDiv);
      expect(element.classes.contains('test'), isFalse);
      element.classes.add('test');
      element.classes.add('test');
      expect(element.outerHtml, '<div class="test"></div>');
      element = html.createElementHtml('<div class="test"></div>');
      expect(element.classes.contains('test'), isTrue);
      element.classes.add('test');
      element.classes.remove('test');
      element.classes.remove('test');
      try {
        expect(element.outerHtml, '<div class=""></div>');
      } catch (_) {
        // on ie no class is specified
        expect(element.outerHtml, '<div></div>');
      }
    });

    test('createElementHtmlWithValidation', () {});
    test('createElementHtmlNoValidation', () {
      /*
      String fullFlickr = '''
<a href=\'https://www.flickr.com/photos/62771079@N04/15282515877\' title=\'keep_on_screenshot_1280x800 by alexroux77, on Flickr\'><img src=\'https://farm3.staticflickr.com/2947/15282515877_842648d61d_s.jpg\' width=\'75\' height=\'75\' alt=\'keep_on_screenshot_1280x800\'></a>
          ''';
          */

      final img = '''
<img src='https://farm3.staticflickr.com/2947/15282515877_842648d61d_s.jpg' width='75' height='75' alt='keep_on_screenshot_1280x800'>
          ''';
      final element = html.createElementHtml(img, noValidate: true);

//<a href='https://www.flickr.com/photos/62771079@N04/15282515877' title='keep_on_screenshot_1280x800 by alexroux77, on Flickr'><img src='https://farm3.staticflickr.com/2947/15282515877_842648d61d_s.jpg' width='75' height='75' alt='keep_on_screenshot_1280x800'></a>');

      //devPrint('${element} ${new Map.from(element.attributes)}');
      expect(element.attributes['src'],
          'https://farm3.staticflickr.com/2947/15282515877_842648d61d_s.jpg');
//         expect(element.tagName, DIV);
//         expect(element.id, 'test');
//         expect(element.innerHtml, 'inner');
//         expect(element.outerHtml, '<div id='test'>inner</div>');
    });
  });
}
