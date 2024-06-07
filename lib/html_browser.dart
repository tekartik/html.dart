library;

import 'package:tekartik_html/html.dart';

import 'html_web.dart';

/// Browser html provider (used to be base on dart:html but is not the same as html_web)
@Deprecated('use htmlProviderWeb instead of htmlProviderBrowser')
HtmlProvider get htmlProviderBrowser => htmlProviderWeb;
