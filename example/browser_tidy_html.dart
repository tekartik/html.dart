// ignore_for_file: avoid_print

import 'package:tekartik_html/html_universal.dart';
import 'package:tekartik_html/util/html_tidy.dart';
import 'package:web/web.dart';

String keyPrefix = 'tekartik_html.tidy_example.';
String inputKey = '$keyPrefix.input';
String indentKey = '$keyPrefix.indent';

void main() {
  final htmlProvider = htmlProviderUniversal;

  final inputElement =
      document.body!.querySelector('#input') as HTMLTextAreaElement;
  final outputElement =
      document.body!.querySelector('#output') as HTMLPreElement;
  final indentElement =
      document.body!.querySelector('#indent') as HTMLInputElement;

  void convert([_]) {
    final indent = indentElement.value;
    final input = inputElement.value;
    try {
      window.localStorage[inputKey] = input;
      window.localStorage[indentKey] = indent;
    } catch (e) {
      print(e);
    }
    var doc = htmlProvider.createDocument(html: input);
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
