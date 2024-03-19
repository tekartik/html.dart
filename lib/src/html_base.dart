import 'package:tekartik_html/html.dart';

abstract class DocumentBase implements Document {
  HtmlProvider provider;

  DocumentBase(this.provider);
}
