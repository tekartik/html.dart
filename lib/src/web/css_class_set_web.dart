import 'package:tekartik_html/html.dart';
import 'package:web/web.dart' as web;

/// A wrapper around the browser DOMTokenList providing the public
/// CssClassSet API.
class CssClassSetWeb extends CssClassSet {
  /// The underlying DOM token list.
  final web.DOMTokenList _domTokenList;

  /// Creates a [CssClassSetWeb] with the given DOM token list.
  CssClassSetWeb(this._domTokenList);

  /// Adds the CSS class [value] to the underlying token list.
  @override
  void add(String value) {
    _domTokenList.add(value);
  }

  /// Removes the CSS class [value] from the underlying token list.
  @override
  void remove(String value) {
    return _domTokenList.remove(value);
  }

  /// Returns true if the underlying token list contains [value].
  @override
  bool contains(String value) {
    return _domTokenList.contains(value);
  }
}
