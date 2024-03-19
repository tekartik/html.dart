import 'dart:html' as html;

import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/html_web.dart';

export 'package:tekartik_html/html_web.dart';

var _provider = htmlProviderWeb;
HtmlProvider htmlProviderUniversal = _provider;

final currentHtmlDocument = _provider.wrapDocument(html.document);
