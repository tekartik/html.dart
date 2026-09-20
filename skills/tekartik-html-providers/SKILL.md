---
name: tekartik-html-providers
description: >-
  Use when choosing or wiring the tekartik_html backend for a platform:
  htmlProviderHtml5Lib (package:html, works everywhere), htmlProviderWeb
  (package:web, browser only), htmlProviderUniversal and currentHtmlDocument
  from html_universal.dart, the deprecated htmlProviderBrowser, the
  HtmlProvider interface (createDocument, createElementTag, createElementHtml,
  wrapDocument/unwrapDocument, wrapElement/unwrapElement, wrapNode/unwrapNode),
  provider name checks (providerHtml5LibName, providerWebName,
  HtmlProviderHtml5Lib, HtmlProviderWeb), the git dependency block, and
  running the same tests against both backends.
---

# tekartik_html: picking an html provider (tekartik_html)

`tekartik_html` is one abstract DOM-shaped API (`HtmlProvider`, `Document`,
`Element`, `Node`) with two interchangeable backends: an in-memory tree over
`package:html` that runs anywhere, and a real DOM over `package:web` that only
runs in a browser. Code written against `HtmlProvider` works on both.

The API of the objects themselves (queries, attributes, tidy printing) is
covered by [tekartik-html-dom](../tekartik-html-dom/SKILL.md).

## Guidelines

* Dependency (git, not on pub.dev; single package repo, so no `path:`):
  ```yaml
  dependencies:
    tekartik_html:
      git:
        url: https://github.com/tekartik/html.dart
      version: '>=0.2.0'
  ```
* Entry points — each provider library re-exports `html.dart`, so one import
  gives both the types and the provider:
  * `package:tekartik_html/html.dart` — the abstract types only
    (`HtmlProvider`, `Document`, `Element`, `Node`, `Text`, `ElementList`,
    `CssClassSet`, `DataSet`, `QueryCriteria`, `DocumentMixin`,
    `ElementExtension`). Use it in code that receives a provider.
  * `package:tekartik_html/html_html5lib.dart` — `htmlProviderHtml5Lib` and
    the marker type `HtmlProviderHtml5Lib`.
  * `package:tekartik_html/html_web.dart` — `htmlProviderWeb` and
    `HtmlProviderWeb`.
  * `package:tekartik_html/html_universal.dart` — `htmlProviderUniversal`,
    `currentHtmlDocument`, plus both providers and their marker types.
  * `package:tekartik_html/html_browser.dart` — deprecated,
    `htmlProviderBrowser` just forwards to `htmlProviderWeb`; do not use it in
    new code (the old `dart:html` backend is gone).
* `htmlProviderHtml5Lib` parses and builds an in-memory html5lib tree: no
  browser needed, so it is the provider for CLI tools, servers, build steps and
  VM tests. `htmlProviderWeb` wraps the live `package:web` DOM: the import
  compiles everywhere, but reading the getter off a web target throws
  `UnsupportedError('Web only')`.
* `htmlProviderUniversal` resolves to `htmlProviderWeb` when compiled for the
  web (`dart.library.js_interop`) and to `htmlProviderHtml5Lib` otherwise, so
  a single import works for code shared between a browser app and its VM
  tests. `currentHtmlDocument` is the wrapped live page document on the web and
  throws `UnsupportedError('web only')` elsewhere — only touch it in code that
  really runs in the browser.
* Keep the provider in one place: take an `HtmlProvider` parameter (or a field)
  in shared code and pass `htmlProviderUniversal` / `htmlProviderHtml5Lib` from
  `main` or from a test. Never assume a global document off the browser.
* Branch on the backend with `html is HtmlProviderHtml5Lib` /
  `html is HtmlProviderWeb`, or on `html.name` against `providerHtml5LibName`
  (`'html5lib'`), `providerWebName` (`'web'`) and the legacy
  `providerBrowserName` (`'browser'`).
* Bridging to native objects: `wrapDocument`/`wrapElement`/`wrapNode` take the
  backend's own object (a `package:html` `dom.Document`/`dom.Element` for
  html5lib, a `package:web` `web.Document`/`web.Element` for web) and return
  the abstract type; `unwrapDocument`/`unwrapElement`/`unwrapNode` return the
  native object as `Object`, so cast it. Unwrapping twice gives the *identical*
  native object, but wrapping twice gives two `==` (not identical) wrappers.
  A wrapper only accepts objects of its own backend.
* Parsing differences are real: the web backend goes through the browser parser
  (it sanitizes and can drop unknown elements such as a `<meta>` inside a
  `<div>`), html5lib keeps them. Pass `noValidate: true` to
  `createElementHtml`/`createElementsHtml`/`createNodesHtml` to keep custom
  markup, and test both providers when the markup is unusual.
* Tests: write the body as `void testMain(HtmlProvider html)` in a shared file,
  then one entry per provider — a VM test on `htmlProviderHtml5Lib` and a
  `@TestOn('browser')` test on `htmlProviderWeb` (and on
  `htmlProviderUniversal`). `dart test -p vm,chrome` with a `dart_test.yaml`
  listing both platforms runs them all.

## Examples

### CLI / server: the html5lib provider

```dart
import 'package:tekartik_html/html_html5lib.dart';

void main() {
  final html = htmlProviderHtml5Lib;
  final doc = html.createDocument(title: 'test');
  doc.body.append(html.createElementTag('div')..text = 'Some text');
  print(doc.toString());
}
```

### Browser: the live document through the universal provider

```dart
import 'package:tekartik_html/html_universal.dart';

void main() {
  final html = htmlProviderUniversal; // web provider once compiled to js/wasm
  final doc = currentHtmlDocument; // only valid in the browser
  doc.title = 'updated title';
  doc.body.append(html.createElementTag('div')..text = 'Some text');
}
```

### Shared code that takes a provider

```dart
import 'package:tekartik_html/html.dart';

/// Works with any backend.
Document buildPage(HtmlProvider html, String title, List<String> items) {
  final doc = html.createDocument(title: title);
  final ul = html.createElementTag('ul');
  for (final item in items) {
    ul.appendElementTag('li').text = item;
  }
  doc.body.append(ul);
  if (html.name == providerWebName) {
    doc.body.classes.add('live');
  }
  return doc;
}
```

### Wrap and unwrap native objects

```dart
import 'package:html/dom.dart' as html5lib;
import 'package:tekartik_html/html_html5lib.dart';

/// Reuse an existing html5lib document.
Document adopt(html5lib.Document native) =>
    htmlProviderHtml5Lib.wrapDocument(native);

/// Escape hatch: get the html5lib element back for an api this package
/// does not expose.
html5lib.Element native(Element element) =>
    htmlProviderHtml5Lib.unwrapElement(element) as html5lib.Element;
```

```dart
import 'package:tekartik_html/html_web.dart';
import 'package:web/web.dart' as web;

/// Browser only: wrap a real DOM element.
Element wrapQuerySelector(String selector) {
  final native = web.document.querySelector(selector)!;
  return htmlProviderWeb.wrapElement(native);
}
```

### One test suite, both providers

```dart
// test/html5lib_test.dart — the browser variant is the same file with
// `@TestOn('browser')` and `htmlProviderWeb`, `test_runner.dart` style: put
// `testMain` in a shared file and import it from each platform entry.
import 'package:tekartik_html/html_html5lib.dart';
import 'package:test/test.dart';

void testMain(HtmlProvider html) {
  group(html.name, () {
    test('document', () {
      final doc = html.createDocument(title: 'test');
      expect(doc.title, 'test');
      expect(doc.body.children.length, 0);
    });
  });
}

void main() {
  testMain(htmlProviderHtml5Lib);
}
```

## Common mistakes

* Reading `htmlProviderWeb` or `currentHtmlDocument` from VM code or a VM
  test: both throw `UnsupportedError`; use `htmlProviderHtml5Lib` (or
  `htmlProviderUniversal`).
* Using `htmlProviderBrowser` / `html_browser.dart`: deprecated alias of
  `htmlProviderWeb`.
* Passing an object of one backend to the other provider's `wrap*`.
* Expecting two wrappers of the same native node to be `identical`; they are
  only `==`.
* Hardcoding `dart:html`: the package does not use it anymore, the browser
  backend is `package:web`.
