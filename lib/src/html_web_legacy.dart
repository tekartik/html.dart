import 'dart:html' as html;

import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/html_browser.dart';

export 'package:tekartik_html/html_browser.dart';

HtmlProvider htmlProviderUniversal = htmlProviderBrowser;

final currentHtmlDocument = htmlProviderBrowser.wrapDocument(html.document);
