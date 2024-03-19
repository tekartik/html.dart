import 'package:tekartik_html/html.dart';
import 'package:web/web.dart' as web;

class CssClassSetWeb extends CssClassSet {
  final web.DOMTokenList _domTokenList;
  CssClassSetWeb(this._domTokenList);

  @override
  void add(String value) {
    _domTokenList.add(value);
  }

  @override
  void remove(String value) {
    return _domTokenList.remove(value);
  }

  @override
  bool contains(String value) {
    return _domTokenList.contains(value);
  }
}
