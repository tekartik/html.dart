import 'package:tekartik_html/attr.dart';
import 'package:tekartik_html/html.dart';

/// Implementation of [CssClassSet] backed by a attributes map (html5lib).
///
/// Keeps an in-memory set of classes and writes back to the attributes map when
/// modified.
class CssClassSetImpl extends CssClassSet {
  final Map _attributes;
  final _classSet = <String>{};

  /// Creates a [CssClassSetImpl] with the given attributes map.
  CssClassSetImpl(this._attributes) {
    final classesStr = _attributes[attrClass]?.toString();
    if ((classesStr != null) && (classesStr.isNotEmpty)) {
      _classSet.addAll(classesStr.split(' '));
    }
  }

  void _write() {
    if (_classSet.isEmpty) {
      //_attributes.remove(CLASS);
      _attributes[attrClass] = ''; // mimic dart_html where class is left empty
    } else {
      _attributes[attrClass] = _classSet.join(' ');
    }
  }

  /// Adds [value] to the class set. Returns true if the set changed.
  @override
  // ignore: avoid_returning_null_for_void
  void add(String value) {
    if (_classSet.add(value)) {
      _write();
    }
  }

  /// Removes [value] from the class set. Returns true if the set changed.
  @override
  void remove(String value) {
    if (_classSet.remove(value)) {
      _write();
    }
  }

  /// Returns true if [value] is present in the class set.
  @override
  bool contains(String value) {
    return _classSet.contains(value);
  }
}
