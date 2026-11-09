# tekartik_html

One DOM-like API (`HtmlProvider`, `Document`, `Element`, `Node`) to build,
parse, query and pretty print html, with two interchangeable backends:

* `htmlProviderHtml5Lib`: an in-memory tree over
  [package:html](https://pub.dev/packages/html). It runs everywhere: Dart VM
  (CLI, server, tests), Flutter, browser and node.
* `htmlProviderWeb`: the live browser DOM over
  [package:web](https://pub.dev/packages/web). Browser only (dart2js and
  dart2wasm).

Code written against `HtmlProvider` runs on both: html generation can be shared
between a CLI or a server and a web app, and tested on the Dart VM.

## Getting started

The package is not on pub.dev, add it as a git dependency:

```yaml
dependencies:
  tekartik_html:
    git:
      url: https://github.com/tekartik/html.dart
```

Build, query and print a document:

```dart
import 'package:tekartik_html/html_html5lib.dart';
import 'package:tekartik_html/util/html_tidy.dart';

void main() {
  final html = htmlProviderHtml5Lib;
  final doc = html.createDocument(title: 'Hello');
  doc.body.appendElementTag('p').text = 'Some text';
  doc.body.appendElementHtml('<ul><li>one</li><li>two</li></ul>');

  final items = doc.body.queryAll(byTag: 'li').map((li) => li.text);
  print(items.toList()); // [one, two]

  print(doc); // the html text, on one line
  print(htmlTidyDocument(doc).join('\n')); // indented, one tag per line
}
```

## Which provider

| Provider                | Import                                      | Runs on                                                    |
|-------------------------|---------------------------------------------|------------------------------------------------------------|
| `htmlProviderHtml5Lib`  | `package:tekartik_html/html_html5lib.dart`  | everywhere                                                 |
| `htmlProviderWeb`       | `package:tekartik_html/html_web.dart`       | browser only (`UnsupportedError` elsewhere)                |
| `htmlProviderUniversal` | `package:tekartik_html/html_universal.dart` | the web provider in a browser, html5lib everywhere else    |

`html_universal.dart` also gives `currentHtmlDocument`, the page the app runs
in (browser only). `package:tekartik_html/html.dart` holds the types only: use
it in code that takes an `HtmlProvider` parameter.

## When to use what

* Create everything through the provider: `createDocument({html, title,
  charset})` (a whole page, `html:` parses one), `createElementTag('div')`,
  `createElementHtml(markup)` (the first element of the markup),
  `createElementsHtml` (all the elements), `createNodesHtml` (elements and
  text), `createTextNode`.
* Append helpers on any node: `appendElementTag`, `appendElementHtml`,
  `appendText`, `appendLf`, `appendChildren`, `replaceWith`.
* Queries search the descendants, not the element itself:
  * `querySelector(css)` / `querySelectorAll(css)` take a CSS selector.
  * `query(byTag:, byId:, byClass:, byAttributes:)` / `queryAll(...)` and
    `queryCriteria(QueryCriteria(..., recursive: false))` match an id or a
    class name as is (`'1a'` or `'md:flex'` work), `byAttributes` is the inside
    of a CSS attribute selector (`'type="text"'`).
* `package:tekartik_html/util/html_tidy.dart`: `htmlTidyDocument(doc)` and
  `htmlTidyElement(element)` return the lines of an indented copy (text wrapped
  at 80 characters, comments dropped, `pre` and `textarea` kept as is).
* `package:tekartik_html/html_utils.dart`: `findFirstAncestorWithId`,
  `findFirstAncestorWithClass`.
* `tag.dart` and `attr.dart`: tag and attribute name constants.

## Common pitfalls

* A `Document` is not an `Element`: query and append through `doc.body`,
  `doc.head` or `doc.html`.
* `children` is an `ElementList` (an `Iterable`, not a `List`) and `classes`
  only has `add`, `remove` and `contains`. Copy (`toList()`) before changing
  the children you iterate.
* Parse a whole page with `createDocument(html: page)`, not with
  `createElementHtml`.
* `noValidate` is ignored by both providers (kept for compatibility): nothing
  is sanitized.
* The two providers still differ on a few edge cases:
  `createElementHtml` with several top level elements throws on html5lib and
  returns the first one on the web; `children.clear()` also removes the text
  nodes on html5lib; `document.title` is not trimmed on html5lib; a `th`
  alone can only be created on the web. Run your tests on both providers
  (`dart test -p vm,chrome`).
* `htmlProviderWeb` and `currentHtmlDocument` throw outside a browser: use
  `htmlProviderUniversal` or `htmlProviderHtml5Lib` in shared code and VM
  tests.

## More

* [example/io_example.dart](example/io_example.dart) (VM),
  [example/browser_example.dart](example/browser_example.dart) (browser),
  [example/io_tidy_html.dart](example/io_tidy_html.dart) (tidy html files from
  the command line).
* Agent skills: [skills/tekartik-html-providers](skills/tekartik-html-providers/SKILL.md)
  (picking a provider, wrapping native objects, testing both) and
  [skills/tekartik-html-dom](skills/tekartik-html-dom/SKILL.md) (the DOM API,
  queries, tidy).
