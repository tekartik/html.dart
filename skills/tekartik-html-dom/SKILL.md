---
name: tekartik-html-dom
description: >-
  Use when building, parsing, querying or printing html with the tekartik_html
  abstract DOM: createDocument, createElementTag, createElementHtml,
  createElementsHtml, createNodesHtml, createTextNode, Document body/head/title
  and fixMissing, Element querySelector/querySelectorAll and the criteria
  queries query/queryAll/queryCriteria/QueryCriteria, attributes, classes
  (CssClassSet), dataset (DataSet), children/ElementList, the append helpers
  (appendElementTag, appendElementHtml, appendText, appendLf, appendChildren,
  replaceWith, childIndex), findFirstAncestorWithId/Class from html_utils.dart,
  htmlTidyDocument/htmlTidyElement/HtmlTidyOption from util/html_tidy.dart and
  the tag.dart / attr.dart constants.
---

# tekartik_html: building and querying documents (tekartik_html)

Every object comes from an `HtmlProvider`: `Document`, `Element`, `Node` and
`Text` are abstract types implemented by both backends, so the code below runs
unchanged on the html5lib tree and on the browser DOM. Picking the provider is
covered by [tekartik-html-providers](../tekartik-html-providers/SKILL.md).

## Guidelines

* Everything is created through the provider, never with a constructor:
  `html.createDocument({html, title, charset, noCharsetTitleFix})`,
  `html.createElementTag('div')`, `html.createTextNode('text')`, and the
  parsing helpers `html.createElementHtml(markup, {noValidate})` (first
  element), `html.createElementsHtml` (all elements) and
  `html.createNodesHtml` (elements *and* text nodes, keeps whitespace).
* `createDocument()` produces a full `<html><head><meta charset="utf-8">
  <title>...</title></head><body></body></html>`; pass `charset: null` for no
  meta charset, `noCharsetTitleFix: true` to keep the parsed html as is, and
  `html:` to parse an existing page. `createElementHtml('<html>...')` throws on
  every backend, and `'<head>...'` / `'<body>...'` throw on the web backend
  (html5lib accepts them) — parse whole pages with `createDocument(html: ...)`.
* `Document` is not an `Element`: it exposes `body`, `head`, `html` (the root
  element), `title`, `fixMissing({title, charset})` and `htmlProvider`. Query
  and append through `doc.body` / `doc.head` / `doc.html`. `doc.toString()`
  serializes the whole document.
* `Element` carries the familiar surface: `tagName`, `id`, `text` (get/set),
  `innerHtml` (get/set), `outerHtml`, `children` (an `ElementList`),
  `childNodes` (`List<Node>`), `parent`, `append(node)`, `appendChild`,
  `insertBefore(newNode, refNode)`, `removeChild`, `replaceChild`, `remove()`,
  `getElementById`, `setAttribute`/`getAttribute`/`hasAttribute`/
  `removeAttribute`.
* Two query families:
  * CSS: `element.querySelector(selector)` and `querySelectorAll(selector)`.
  * Criteria: `element.query(byTag:, byId:, byClass:, byAttributes:)` /
    `queryAll(...)`, or `queryCriteria(QueryCriteria(byTag: 'div', byClass:
    'x', recursive: false))` / `queryCriteriaAll(...)`. `recursive` defaults to
    `true`; use the criteria form when the selector would have to be built by
    string concatenation.
  Both search descendants only, never the element itself.
* Collections are small abstractions, not Dart collections: `ElementList` is an
  `Iterable<Element>` with `[]`, `[]=`, `add`, `insert`, `removeAt`, `remove`,
  `indexOf`, `clear` and `length`; `CssClassSet` only has `add`, `remove`,
  `contains`; `DataSet` (the `data-*` attributes, without the prefix) has `[]`,
  `[]=`, `keys` and `remove`; `attributes` is a `Map<Object, String>` (use
  string keys). Call `.toList()` before sorting or indexing repeatedly.
* Append helpers (extension `TekartikHtmlNodeExt` on `Node`, exported by
  `html.dart`): `appendElementTag('li')` (creates *and* appends, returns the
  element), `appendElementHtml(markup, {noValidate})`,
  `appendElementsHtml`, `appendNodesHtml`, `appendText('x')`, `appendLf()`,
  `appendChildren(list)` and `node.replaceWith(other)`. `ElementExtension`
  adds `element.childIndex` (index in its parent).
* Node level: `nodeType` compared with `Node.elementNode`, `Node.textNode`,
  `Node.commentNode`... , `nodeValue`, `textContent` (nullable, on any node)
  and `parentNode`. `Text` is a `Node` with a non-null `text`.
* Constants instead of magic strings: `package:tekartik_html/tag.dart`
  (`tagHtml`, `tagMeta`, `tagTitle`, `tagDiv`, `tagSpan`, `tagA`, `tagP`) and
  `package:tekartik_html/attr.dart` (`attrClass`, `attrCharset`,
  `attrCharsetUtf8`, `attrDataPrefix`).
* Ancestor lookup: `findFirstAncestorWithId(element, id, [includeElement])` and
  `findFirstAncestorWithClass(element, className, [includeElement])` from
  `package:tekartik_html/html_utils.dart` return `null` when nothing matches.
* Pretty printing: `htmlTidyDocument(document, [option])` and
  `htmlTidyElement(element, [option])` from
  `package:tekartik_html/util/html_tidy.dart` return an `Iterable<String>` of
  lines — `join('\n')` them. `HtmlTidyOption()..indent = '  '` (default is a
  tab) and `..contentLength = 80` (text wrapping) control the output. The
  result is a formatted copy, the document is not modified.
* `DocumentMixin` (from `html.dart`) is only for implementing a new backend; it
  provides the shared `fixMissing` logic.

## Examples

### Build a document and print it

```dart
import 'package:tekartik_html/html_html5lib.dart';
import 'package:tekartik_html/tag.dart';
import 'package:tekartik_html/util/html_tidy.dart';

void main() {
  final html = htmlProviderHtml5Lib;
  final doc = html.createDocument(title: 'Report');

  final div = doc.body.appendElementTag(tagDiv)..id = 'content';
  div.classes.add('main');
  final ul = div.appendElementTag('ul');
  for (final day in ['monday', 'tuesday']) {
    ul.appendElementTag('li').text = day;
    ul.appendLf();
  }
  div.appendElementHtml('<p>generated</p>');

  print(htmlTidyDocument(doc, HtmlTidyOption()..indent = '  ').join('\n'));
}
```

### Parse html, query and edit

```dart
import 'package:tekartik_html/html.dart';

/// Adds a css class to every link of the page and returns their targets.
List<String> decorateLinks(HtmlProvider html, String pageHtml) {
  final doc = html.createDocument(html: pageHtml);
  final hrefs = <String>[];
  for (final link in doc.body.querySelectorAll('a')) {
    link.classes.add('external');
    link.dataset['tracked'] = 'true'; // data-tracked="true"
    final href = link.getAttribute('href');
    if (href != null) {
      hrefs.add(href);
    }
  }
  final title = doc.body.querySelector('#title');
  title?.text = 'Updated';
  return hrefs;
}
```

### Criteria queries and ancestors

```dart
import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/html_utils.dart';

/// All direct children `div` of [root] having the class `card`.
ElementList cards(Element root) => root.queryCriteriaAll(
  QueryCriteria(byTag: 'div', byClass: 'card', recursive: false),
);

/// The enclosing section id of an element, if any.
String? sectionId(Element element) =>
    findFirstAncestorWithClass(element, 'section', true)?.id;

/// Shorthand form of the same query.
Element? firstCard(Element root) => root.query(byClass: 'card');
```

### Tidy a file from the command line

```dart
import 'dart:io';

import 'package:args/args.dart';
import 'package:tekartik_html/html_html5lib.dart';
import 'package:tekartik_html/util/html_tidy.dart';

void main(List<String> arguments) {
  final parser = ArgParser(allowTrailingOptions: true);
  parser.addOption(
    'indent',
    abbr: 'i',
    defaultsTo: HtmlTidyOption().indent,
  );
  final results = parser.parse(arguments);
  final html = htmlProviderHtml5Lib;
  final indent = results['indent']?.toString();
  for (final path in results.rest) {
    final doc = html.createDocument(html: File(path).readAsStringSync());
    final option = HtmlTidyOption()..indent = indent;
    for (final line in htmlTidyDocument(doc, option)) {
      stdout.writeln(line);
    }
  }
}
```

### Node level surgery

```dart
import 'package:tekartik_html/html.dart';

/// Replaces every `<b>` by a `<strong>` keeping the text, and drops
/// whitespace-only text nodes.
void modernize(HtmlProvider html, Element root) {
  for (final b in root.querySelectorAll('b').toList()) {
    final strong = html.createElementTag('strong')..text = b.text;
    b.replaceWith(strong);
  }
  for (final node in List.of(root.childNodes)) {
    if (node.nodeType == Node.textNode &&
        (node.textContent ?? '').trim().isEmpty) {
      root.removeChild(node);
    }
  }
}

/// Insert an element right before another one.
void insertBanner(HtmlProvider html, Element parent, Element before) {
  final banner = html.createElementTag('div')..text = 'banner';
  parent.insertBefore(banner, before);
  print('banner at index ${banner.childIndex}');
}
```

## Common mistakes

* Calling `querySelector` on a `Document`: go through `doc.body`, `doc.head`
  or `doc.html`.
* Treating `children` as a `List` (no `sort`, no `[]` growth semantics) or
  `classes` as a `Set` (only `add`/`remove`/`contains`).
* Mutating `children`/`childNodes` while iterating them: copy with
  `List.of(...)` or `.toList()` first.
* Parsing a whole page with `createElementHtml`: `'<html>...'` throws (and
  `'<head>'`/`'<body>'` throw in the browser); use `createDocument(html: ...)`.
* Expecting `query(byClass: 'a b')` to behave like a CSS selector list; the
  criteria are matched one by one, use `querySelector` for real selectors.
* Assuming `htmlTidyDocument` formats the document in place: it returns lines.
