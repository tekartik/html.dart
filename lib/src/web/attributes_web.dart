import 'dart:collection';
import 'package:web/web.dart' as web;

class AttributesWeb extends MapBase<String, String> {
  final web.Document webDoc;
  final web.NamedNodeMap webNamedNodeMap;

  AttributesWeb(this.webDoc, this.webNamedNodeMap);
  @override
  String? operator [](Object? key) {
    return webNamedNodeMap.getNamedItem(key as String)?.value;
  }

  @override
  void operator []=(String key, String value) {
    webNamedNodeMap.setNamedItem(webDoc.createAttribute(key)..value = value);
  }

  @override
  void clear() {
    for (var i = 0; i < webNamedNodeMap.length; i++) {
      webNamedNodeMap.removeNamedItem(webNamedNodeMap.item(i)!.name);
    }
  }

  @override
  Iterable<String> get keys {
    var keys = <String>[];
    for (var i = 0; i < webNamedNodeMap.length; i++) {
      keys.add(webNamedNodeMap.item(i)!.name);
    }
    return keys;
  }

  @override
  String? remove(Object? key) {
    var attr = webNamedNodeMap.getNamedItem(key as String);
    if (attr != null) {
      webNamedNodeMap.removeNamedItem(key);
      return attr.value;
    }
    return null;
  }
}
