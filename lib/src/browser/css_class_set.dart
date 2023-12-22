import 'dart:html' as dart_html;

import 'package:tekartik_html/html.dart';

class CssClassSetBrowser extends CssClassSet {
  final dart_html.CssClassSet _cssClassSet;
  CssClassSetBrowser(this._cssClassSet);

  @override
  bool add(String value) {
    return _cssClassSet.add(value);
  }

  @override
  bool remove(Object value) {
    return _cssClassSet.remove(value);
  }

  @override
  bool contains(Object value) {
    return _cssClassSet.contains(value);
  }
}
