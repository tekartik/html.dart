import 'dart:html';

import 'package:tekartik_html/html_browser.dart';
import 'package:tekartik_html/util/html_tidy.dart';

String keyPrefix = 'tekartik_html.tidy_example.';
String inputKey = '${keyPrefix}.input';
String indentKey = '${keyPrefix}.indent';

void main() {
  final _html = htmlProviderBrowser;

  final inputElement =
      document.body!.querySelector('#input') as TextAreaElement;
  final outputElement = document.body!.querySelector('#output') as PreElement;
  final indentElement = document.body!.querySelector('#indent') as InputElement;

  void convert([_]) {
    final indent = indentElement.value!;
    final input = inputElement.value!;
    try {
      window.localStorage[inputKey] = input;
      window.localStorage[indentKey] = indent;
    } catch (e) {
      print(e);
    }
    var doc = _html.createDocument(html: input);
    outputElement.text =
        htmlTidyDocument(doc, HtmlTidyOption()..indent = indent).join('\n');
  }

  // reload last if any
  final input = window.localStorage[inputKey];
  var indent = window.localStorage[indentKey];

  // get the default indent
  indent ??= HtmlTidyOption().indent;

  if (indent != null) {
    indentElement.value = indent;
  }
  if (input != null) {
    inputElement.value = input;
  }
  // reconvert last
  if (input != null) {
    convert();
  }

  document.body!.querySelector('#convert')!.onClick.listen(convert);
}
