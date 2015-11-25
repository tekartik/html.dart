# tekartik_html.dart

An html abstraction layer to work with both dart:html and the html package

[![Build Status](https://travis-ci.org/alextekartik/tekartik_html.dart.svg?branch=master)](https://travis-ci.org/alextekartik/tekartik_html.dart)

## General

Opiniated generic API

## Usage


### Choosing the provider

For browser app using the native DOM API

    import 'package:tekartik_html/html.dart';
    import 'package:tekartik_html/html_browser.dart';

    main() {
      HtmlProvider html = htmlProviderBrowser;
    }

For io/browser app using the html (former html5) package

    import 'package:tekartik_html/html.dart';
    import 'package:tekartik_html/html_html5lib.dart';

    main() {
      HtmlProvider html = htmlProviderHtml5Lib;
    }

The api is then ready to use

### Creating document

    Document doc = html.createDocument(title: 'test');

### Adding element

    Element div = html.createElementTag('div')..text = 'Some text';
    doc.body.append(div);


## Build status

Travis: [![Build Status](https://travis-ci.org/alextekartik/tekartik_html.dart.svg?branch=master)](https://travis-ci.org/alextekartik/tekartik_html.dart)
