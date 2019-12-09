#!/usr/bin/env dart
import 'dart:io';

import 'package:args/args.dart';
import 'package:tekartik_html/html_html5lib.dart';
import 'package:tekartik_html/util/html_tidy.dart';

void main(List<String> arguments) {
  final parser = ArgParser(allowTrailingOptions: true);
  parser.addOption('indent',
      abbr: 'i',
      valueHelp: 'indent value (default to tab)',
      defaultsTo: HtmlTidyOption().indent);
  final results = parser.parse(arguments);

  final html = htmlProviderHtml5Lib;
  final indent = results['indent']?.toString();
  for (final inputFile in results.rest) {
    print(inputFile);
    final input = File(inputFile).readAsStringSync();
    var doc = html.createDocument(html: input);
    final list =
        htmlTidyDocument(doc, HtmlTidyOption()..indent = indent)?.toList();
    for (final line in list) {
      stdout.writeln(line);
    }
  }
}
