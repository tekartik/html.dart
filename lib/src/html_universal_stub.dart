import 'package:tekartik_html/html_html5lib.dart';

/// Universal HTML provider using HTML5lib (stub implementation).
HtmlProvider htmlProviderUniversal = htmlProviderHtml5Lib;

/// Web only
/// Gets the current HTML document (throws on non-web platforms).
Document get currentHtmlDocument => throw UnsupportedError('web only');
