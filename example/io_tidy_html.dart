#!/usr/bin/env dart
import 'package:args/args.dart';

import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/util/html_tidy.dart';
import 'package:tekartik_html/html_html5lib.dart';
import 'dart:io';

main(List<String> arguments) {
  ArgParser parser = new ArgParser(allowTrailingOptions: true);
  parser.addOption('indent',
      abbr: 'i',
      valueHelp: "indent value (default to tab)",
      defaultsTo: new HtmlTidyOption().indent);
  ArgResults results = parser.parse(arguments);

  HtmlProvider html = htmlProviderHtml5Lib;
  String indent = results['indent'];
  for (String inputFile in results.rest) {
    print(inputFile);
    String input = new File(inputFile).readAsStringSync();
    var doc = html.createDocument(html: input);
    List<String> list =
        htmlTidyDocument(doc, new HtmlTidyOption()..indent = indent);
    for (String line in list) {
      stdout.writeln(line);
    }
  }
}
