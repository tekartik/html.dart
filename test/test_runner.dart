library all_tests;

//import 'html_provider_test.dart';
import 'package:tekartik_html/html.dart';
import 'document_test.dart' as document_test;
import 'element_test.dart' as element_test;
import 'html_utils_test.dart' as html_utils_test;

void test_main(HtmlProvider provider) {
  document_test.test_main(provider);
  element_test.test_main(provider);
  html_utils_test.test_main(provider);
}
