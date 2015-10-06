library all_tests;

//import 'html_provider_test.dart';
import 'package:tekartik_html/html.dart';
import 'document_test.dart' as document_test;
import 'element_test.dart' as element_test;

void test_main(HtmlProvider provider) {
  document_test.test_main(provider);
  element_test.test_main(provider);
}
