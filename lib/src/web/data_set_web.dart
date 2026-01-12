import 'package:tekartik_html/html.dart';

import 'attributes_web.dart';

var _dataPrefix = 'data-';

String _dataKey(String name) => '$_dataPrefix$name';

/// A DataSet implementation backed by an [AttributesWeb] map (HTML5 data-*).
class DataSetWeb extends DataSet {
  /// The underlying attributes map.
  final AttributesWeb _attributes;

  /// Creates a [DataSetWeb] with the given attributes map.
  DataSetWeb(this._attributes);

  /// Gets the data attribute named [name] (without the 'data-' prefix).
  @override
  String? operator [](String name) {
    return _attributes[_dataKey(name)];
  }

  /// Sets the data attribute named [name] (without the 'data-' prefix) to [value].
  @override
  void operator []=(String name, String value) {
    _attributes[_dataKey(name)] = value;
  }

  /// Returns the collection of data- attribute keys (without the 'data-' prefix).
  @override
  Iterable<String> get keys => _attributes.keys
      .where((key) => key.startsWith(_dataPrefix))
      .map((e) => e.substring(_dataPrefix.length));

  /// Removes the data attribute identified by [key] and returns true if it existed.
  @override
  bool remove(String key) {
    return _attributes.remove(_dataKey(key)) != null;
  }
}
