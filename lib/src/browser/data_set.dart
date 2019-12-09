part of html_browser;

class DataSetBrowser extends DataSet {
  final Map<String, String> _dataset;

  DataSetBrowser(this._dataset);

  @override
  String operator [](String name) {
    return _dataset[name];
  }

  @override
  void operator []=(String name, String value) {
    _dataset[name] = value;
  }

  @override
  Iterable<String> get keys => _dataset.keys;

  @override
  bool remove(String key) {
    return _dataset.remove(key) != null;
  }
  //String get name =>
  /*
  CssClassSetBrowser(this._cssClassSet);
  

  @override
  bool add(String value) {
    return _cssClassSet.add(value);
  }

 
  
  @override
  bool contains(Object value) {
    return _cssClassSet.contains(value);
  }
  */
}
