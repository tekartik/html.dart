part of html_html5lib;

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
}
