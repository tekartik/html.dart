import 'package:tekartik_html/attr.dart';
import 'package:tekartik_html/html.dart';

/// An HTML5lib-based implementation of a data set for HTML data attributes.
class DataSetHtml5lib extends DataSet {
  final Map<Object, String> _attributes;

  /// Creates a [DataSetHtml5lib] with the given attributes map.
  DataSetHtml5lib(this._attributes);

  String _nameToAttrKey(String name) {
    return '$attrDataPrefix$name';
  }

  @override
  /// Retrieves the value of the data attribute with the given name.
  String? operator [](String name) {
    return _attributes[_nameToAttrKey(name)];
  }

  @override
  /// Sets the value of the data attribute with the given name.
  void operator []=(String name, String value) {
    _attributes['$attrDataPrefix$name'] = value;
  }

  @override
  /// Returns an iterable of all data attribute keys (without the 'data-' prefix).
  Iterable<String> get keys {
    final keys = <String>[];
    for (dynamic key in _attributes.keys) {
      if (key is String) {
        if (key.startsWith(attrDataPrefix)) {
          keys.add(key.substring(attrDataPrefix.length));
        }
      }
    }
    return keys;
  }

  @override
  /// Removes the data attribute with the given key and returns true if it existed.
  bool remove(String key) {
    return _attributes.remove(_nameToAttrKey(key)) != null;
  }
}

//_element.dataset.keys;}
/*
class CssClassSetImpl extends CssClassSet {
  Map _attributes;
  Set<String> _classSet = new Set();
  CssClassSetImpl(this._attributes) {
    String classesStr = _attributes[CLASS];
    if ((classesStr != null) && (classesStr.length > 0)) {
      _classSet.addAll(classesStr.split(' '));
    }
  }
  
  void _write() {
    if (_classSet.isEmpty) {
      //_attributes.remove(CLASS);
      _attributes[CLASS] = ''; // mimic dart_html where class is left empty
    } else {
      _attributes[CLASS] = _classSet.join(' ');
    }
  }
  @override
  bool add(String value) {
    bool added = _classSet.add(value);
    if (added) {
      _write();
    }
    return added;
  }

  @override
  bool remove(Object value) {
    bool removed = _classSet.remove(value);
    if (removed) {
      _write();
    }
    return removed;
  }
  
  @override
  bool contains(Object value) {
    return _classSet.contains(value);
  }
}*/
