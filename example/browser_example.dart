import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/html_browser.dart';
import 'dart:html' as _html;

main() {
  HtmlProvider html = htmlProviderBrowser;

  Document doc = html.wrapDocument(_html.document);

  Element div = html.createElementTag('div')..text = 'Some text';
  doc.body.append(div);

  doc.title = "updated title";

  Element pre = html.createElementTag('pre')..text = doc.toString();
  doc.body.append(pre);
}
