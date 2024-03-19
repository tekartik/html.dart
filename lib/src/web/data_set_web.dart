import 'package:tekartik_html/html.dart';

import 'attributes_web.dart';

var _dataPrefix = 'data-';

String _dataKey(String name) => '$_dataPrefix$name';

class DataSetWeb extends DataSet {
  final AttributesWeb _attributes;

  DataSetWeb(this._attributes);

  @override
  String? operator [](String name) {
    return _attributes[_dataKey(name)];
  }

  @override
  void operator []=(String name, String value) {
    _attributes[_dataKey(name)] = value;
  }

  @override
  Iterable<String> get keys => _attributes.keys
      .where((key) => key.startsWith(_dataPrefix))
      .map((e) => e.substring(_dataPrefix.length));

  @override
  bool remove(String key) {
    return _attributes.remove(_dataKey(key)) != null;
  }
}
