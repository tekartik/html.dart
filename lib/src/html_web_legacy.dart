import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/src/web/html_web.dart' as web;

@Deprecated('Use htmlProviderUniversal from html_universal instead')
HtmlProvider htmlProviderUniversal = web.htmlProviderWeb;

final currentHtmlDocument = web.currentHtmlDocumentWeb;
