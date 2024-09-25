import 'package:tekartik_html/html_web.dart';
import 'package:web/web.dart' as web;

export 'package:tekartik_html/html_web.dart';

var _provider = htmlProviderWeb;
HtmlProvider htmlProviderUniversal = _provider;

final currentHtmlDocument = _provider.wrapDocument(web.document);
