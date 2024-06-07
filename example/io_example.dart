// ignore_for_file: avoid_print

import 'package:tekartik_html/html_html5lib.dart';

void main() {
  final html = htmlProviderHtml5Lib;

  final doc = html.createDocument(title: 'test');

  final div = html.createElementTag('div')..text = 'Some text';
  doc.body.append(div);

  doc.title = 'updated title';

  print(doc.toString());
}
