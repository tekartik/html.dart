import 'package:tekartik_html/html_html5lib.dart';

HtmlProvider htmlProviderUniversal = htmlProviderHtml5Lib;

/// Web only
Document get currentHtmlDocument => throw UnsupportedError('web only');
