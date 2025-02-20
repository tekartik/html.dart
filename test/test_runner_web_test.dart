@TestOn('browser')
library;

import 'package:tekartik_html/html_web.dart';
import 'package:test/test.dart';

import 'test_runner.dart';

Future<void> main() async {
  testMain(htmlProviderWeb);
}
