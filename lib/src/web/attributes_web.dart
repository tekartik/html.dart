import 'dart:collection';
import 'package:web/web.dart' as web;

/// A web-based implementation of a map for HTML element attributes using the web DOM.
class AttributesWeb extends MapBase<String, String> {
  /// The web document associated with the attributes.
  final web.Document webDoc;

  /// The underlying named node map from the web DOM.
  final web.NamedNodeMap webNamedNodeMap;

  /// Creates an [AttributesWeb] instance with the given document and named node map.
  AttributesWeb(this.webDoc, this.webNamedNodeMap);
  @override
  /// Retrieves the value of the attribute with the given key.
  String? operator [](Object? key) {
    return webNamedNodeMap.getNamedItem(key as String)?.value;
  }

  @override
  /// Sets the value of the attribute with the given key.
  void operator []=(String key, String value) {
    webNamedNodeMap.setNamedItem(webDoc.createAttribute(key)..value = value);
  }

  @override
  /// Removes all attributes from the map.
  void clear() {
    for (var i = 0; i < webNamedNodeMap.length; i++) {
      webNamedNodeMap.removeNamedItem(webNamedNodeMap.item(i)!.name);
    }
  }

  @override
  /// Returns an iterable of all attribute keys.
  Iterable<String> get keys {
    var keys = <String>[];
    for (var i = 0; i < webNamedNodeMap.length; i++) {
      keys.add(webNamedNodeMap.item(i)!.name);
    }
    return keys;
  }

  @override
  /// Removes the attribute with the given key and returns its value.
  String? remove(Object? key) {
    var attr = webNamedNodeMap.getNamedItem(key as String);
    if (attr != null) {
      webNamedNodeMap.removeNamedItem(key);
      return attr.value;
    }
    return null;
  }
}
