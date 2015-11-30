import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/util/html_tidy.dart';
import 'package:tekartik_html/html_browser.dart';
import 'dart:html';

String keyPrefix = 'tekartik_html.tidy_example.';
String inputKey = '${keyPrefix}.input';
String indentKey = '${keyPrefix}.indent';
main() {
  HtmlProvider _html = htmlProviderBrowser;

  TextAreaElement inputElement = document.body.querySelector("#input");
  PreElement outputElement = document.body.querySelector("#output");
  InputElement indentElement = document.body.querySelector("#indent");

  convert([_]) {
    String indent = indentElement.value;
    String input = inputElement.value;
    try {
      window.localStorage[inputKey] = input;
      window.localStorage[indentKey] = indent;
    } catch (e) {
      print(e);
    }
    var doc = _html.createDocument(html: input);
    outputElement.text =
        htmlTidyDocument(doc, new HtmlTidyOption()..indent = indent).join('\n');
  }

  // reload last if any
  String input = window.localStorage[inputKey];
  String indent = window.localStorage[indentKey];

  if (indent == null) {
    // get the default indent
    indent = new HtmlTidyOption().indent;
  }
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

  document.body.querySelector('#convert').onClick.listen(convert);
}
