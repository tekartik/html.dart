import 'dart:html' as _html;

import 'package:tekartik_html/html_browser.dart';

void main() {
  final html = htmlProviderBrowser;

  final doc = html.wrapDocument(_html.document);

  final div = html.createElementTag('div')..text = 'Some text';
  doc.body.append(div);

  doc.title = 'updated title';

  final pre = html.createElementTag('pre')..text = doc.toString();
  doc.body.append(pre);
}
