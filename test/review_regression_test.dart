library;

import 'package:tekartik_html/html_html5lib.dart';
import 'package:tekartik_html/util/html_tidy.dart';
import 'package:test/test.dart';

void main() {
  testMain(htmlProviderHtml5Lib);
}

/// Regressions found in the 2026-11-09 review, run for each provider.
void testMain(HtmlProvider html) {
  group('regression', () {
    test('query by id or class not being css identifiers', () {
      var div = html.createElementHtml(
        '<div><p id="1a">x</p><p id="a.b">y</p><p class="md:flex">z</p></div>',
      );
      expect(div.getElementById('1a')?.text, 'x');
      expect(div.query(byId: '1a')?.text, 'x');
      expect(div.queryAll(byId: '1a').map((e) => e.text), ['x']);
      expect(div.queryCriteria(QueryCriteria(byId: 'a.b'))?.text, 'y');
      expect(
        div.queryCriteriaAll(QueryCriteria(byId: 'a.b')).map((e) => e.text),
        ['y'],
      );
      expect(div.query(byClass: 'md:flex')?.text, 'z');
      expect(
        div
            .queryCriteria(QueryCriteria(byClass: 'md:flex', recursive: false))
            ?.text,
        'z',
      );
    });

    test('createElementHtml table parts', () {
      var tr = html.createElementHtml('<tr><td>1</td></tr>');
      expect(tr.tagName, 'tr');
      expect(tr.outerHtml, '<tr><td>1</td></tr>');
      expect(tr.parent, isNull);
      var td = html.createElementHtml(' <td>1</td>');
      expect(td.tagName, 'td');
      expect(html.createElementHtml('<tbody></tbody>').tagName, 'tbody');
    });

    test('svg attribute name case', () {
      var div = html.createElementHtml('<div><svg></svg></div>');
      var svg = div.children.first;
      svg.attributes['viewBox'] = '0 0 1 1';
      expect(svg.getAttribute('viewBox'), '0 0 1 1');
      expect(svg.attributes['viewBox'], '0 0 1 1');
      expect(svg.outerHtml, '<svg viewBox="0 0 1 1"></svg>');
    });

    test('dataset toString', () {
      var div = html.createElementHtml('<div data-a="1" data-b="2"></div>');
      expect(div.dataset.toString(), '{a: 1, b: 2}');
    });

    test('removeChild of a document', () {
      var doc = html.createDocument(
        html: '<html><head></head><body></body></html>',
      );
      var htmlElement = doc.html;
      var parent = htmlElement.parentNode!;
      expect(parent.nodeType, Node.documentNode);
      parent.removeChild(htmlElement);
      expect(htmlElement.parentNode, isNull);
    });

    group('tidy keeps pre and textarea content', () {
      String reparsedText(String outerHtml, String tag) {
        var lines = htmlTidyElement(html.createElementHtml(outerHtml));
        return html
            .createElementHtml(lines.join('\n'))
            .querySelector(tag)!
            .text;
      }

      test('nested pre', () {
        expect(reparsedText('<div><pre>a\n  b</pre></div>', 'pre'), 'a\n  b');
        expect(
          htmlTidyElement(
            html.createElementHtml('<div><pre>a\n  b</pre></div>'),
          ),
          ['<div>', '\t<pre>a\n  b</pre>', '</div>'],
        );
      });

      test('pre with elements', () {
        expect(
          reparsedText(
            '<div><pre><code class="x">a &lt; b\n    c</code></pre></div>',
            'code',
          ),
          'a < b\n    c',
        );
      });

      test('textarea', () {
        expect(
          reparsedText('<div><textarea>a\n  b</textarea></div>', 'textarea'),
          'a\n  b',
        );
      });

      test('leading line feed', () {
        expect(reparsedText('<div><pre>\n\na</pre></div>', 'pre'), '\na');
      });
    });
  });
}
