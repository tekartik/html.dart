import 'package:tekartik_html/attr.dart';
import 'package:tekartik_html/html.dart';

class CssClassSetImpl extends CssClassSet {
  final Map _attributes;
  final _classSet = <String>{};
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

  @override
  bool add(String value) {
    final added = _classSet.add(value);
    if (added) {
      _write();
    }
    return added;
  }

  @override
  bool remove(Object value) {
    final removed = _classSet.remove(value);
    if (removed) {
      _write();
    }
    return removed;
  }

  @override
  bool contains(Object value) {
    return _classSet.contains(value);
  }
}
