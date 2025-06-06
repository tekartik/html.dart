library;

//import 'html_provider_test.dart';
import 'package:tekartik_html/html.dart';

import 'document_test.dart' as document_test;
import 'element_test.dart' as element_test;
import 'html_utils_test.dart' as html_utils_test;
import 'node_test.dart' as node_test;

void testMain(HtmlProvider provider) {
  document_test.testMain(provider);
  element_test.testMain(provider);
  node_test.nodeTestGroup(provider);
  html_utils_test.testMain(provider);
}
