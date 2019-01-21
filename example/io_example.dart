import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/html_html5lib.dart';

void main() {
  HtmlProvider html = htmlProviderHtml5Lib;

  Document doc = html.createDocument(title: 'test');

  Element div = html.createElementTag('div')..text = 'Some text';
  doc.body.append(div);

  doc.title = "updated title";

  print(doc.toString());
}
