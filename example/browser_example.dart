import 'dart:html' as dart_html;

import 'package:tekartik_html/html_browser.dart';
import 'package:tekartik_html/html_universal.dart';

void main() {
  final html = htmlProviderBrowser;

  final doc = html.wrapDocument(dart_html.document);

  final div = html.createElementTag('div')..text = 'Some text';
  doc.body.append(div);

  doc.title = 'updated title';

  final pre = html.createElementTag('pre')..text = doc.toString();
  doc.body.append(pre);

  final univsersalPre = html.createElementTag('pre')
    ..text = 'some text added to current body';
  currentHtmlDocument.body.append(univsersalPre);
}
