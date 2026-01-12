import 'package:tekartik_html/html_web.dart';
import 'package:web/web.dart' as web;

export 'package:tekartik_html/html_web.dart';

/// Universal HTML provider for web environments.
var _provider = htmlProviderWeb;

/// The universal provider exposed by this library (web variant).
HtmlProvider htmlProviderUniversal = _provider;

/// The current HTML document wrapped for web use.
final currentHtmlDocument = _provider.wrapDocument(web.document);
