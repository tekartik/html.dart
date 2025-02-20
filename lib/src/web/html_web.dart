import 'dart:collection';
import 'dart:js_interop';

import 'package:tekartik_html/attr.dart';
import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/src/common_utils.dart';
import 'package:tekartik_html/src/html_base.dart';
import 'package:tekartik_html/src/html_web.dart';
import 'package:web/web.dart' as web;

import 'attributes_web.dart';
import 'css_class_set_web.dart';
import 'data_set_web.dart';

web.Text? textNode;

abstract class NodeWeb implements Node {
  web.Node get webNode;
}

abstract class _NodeBase implements NodeWeb {
  @override
  final web.Node webNode;

  _NodeBase(this.webNode);

  @override
  int get nodeType => webNode.nodeType;

  @override
  String? get nodeValue => webNode.nodeValue;
}

extension NodeWebExt on Node {
  web.Node get webNode => (this as NodeWeb).webNode;
}

class _NodeWebBase extends _NodeBase with _NodeWebMixin implements Node {
  _NodeWebBase(super.node);
}

_Element? _wrapWebElementOrNull(web.Element? webElement) {
  if (webElement == null) {
    return null;
  }
  return _Element(webElement);
}

abstract class ElementWeb implements Element, NodeWeb {
  web.Element get webElement;
}

class _Element extends _NodeBase
    with _NodeWebMixin, _ElementImpl
    implements ElementWeb {
  _Element(web.Element super.element);

  @override
  HtmlProvider get htmlProvider => _html;
}

abstract mixin class _ElementImpl implements ElementWeb {
  @override
  web.Element get webElement => webNode as web.Element;

  @override
  String get id => webElement.id;

  @override
  set id(String id) {
    webElement.id = id;
  }

  @override
  String get innerHtml => webElement.getHTML();

  @override
  set innerHtml(String html) {
    webElement.setHTMLUnsafe(html.toJS);
  }

  /// Text content (good for text node)
  @override
  String? get textContent => webElement.textContent;

  @override
  String get text => webElement.textContent ?? '';

  @override
  set text(String text) {
    webElement.textContent = text;
  }

  @override
  Node append(Node node) {
    webElement.appendChild(node.webNode);
    return node;
  }

  @override
  Map<Object, String> get attributes => AttributesWeb(
      webElement.ownerDocument ?? web.window.document, webElement.attributes);

  @override
  List<Node> get childNodes {
    var childNodes = webElement.childNodes;
    return UnmodifiableListView(List<Node>.generate(
        childNodes.length, (index) => _html.wrapNode(childNodes.item(index)!)));
  }

  @override
  ElementList get children {
    return _ElementList(this, webElement.children);
  }

  @override
  CssClassSet get classes => CssClassSetWeb(webElement.classList);

  @override
  DataSet get dataset => DataSetWeb(attributes as AttributesWeb);

  @override
  Element? getElementById(String id) {
    return queryCriteria(QueryCriteria(byId: id));
  }

  @override
  String get outerHtml => (webElement.outerHTML as JSString).toDart;

  @override
  Element? get parent => _wrapWebElementOrNull(webElement.parentElement);

  @override
  Element? query(
      {String? byTag, String? byId, String? byClass, String? byAttributes}) {
    return querySelector(buildSelector(
        byTag: byTag,
        byId: byId,
        byClass: byClass,
        byAttributes: byAttributes));
  }

  @override
  ElementList queryAll(
      {String? byTag, String? byId, String? byClass, String? byAttributes}) {
    return querySelectorAll(buildSelector(
        byTag: byTag,
        byId: byId,
        byClass: byClass,
        byAttributes: byAttributes));
  }

  @override
  Element? queryCriteria(QueryCriteria criteria) {
    return querySelector(buildCriteriaSelector(criteria));
  }

  @override
  ElementList queryCriteriaAll(QueryCriteria criteria) {
    return querySelectorAll(buildCriteriaSelector(criteria));
  }

  @override
  Element? querySelector(String selector) =>
      _wrapWebElementOrNull(webElement.querySelector(selector));

  @override
  ElementList querySelectorAll(String selector) => _ElementList(
      this, webElement.querySelectorAll(selector) as web.HTMLCollection);

  @override
  void remove() {
    webElement.remove();
  }

  @override
  String get tagName => webElement.tagName.toLowerCase();

  @override
  String toString() {
    return webElement.toString();
  }
}

class _ElementList extends ListBase<Element> implements ElementList {
  final Element parent;
  final web.HTMLCollection webCollection;

  @override
  int get length => webCollection.length;

  @override
  set length(int newLength) {
    throw UnsupportedError('length read only, use insert/add/remove instead');
  }

  _ElementList(this.parent, this.webCollection);

  Element itemAt(int index) {
    return _Element(webCollection.item(index)!);
  }

  @override
  Element operator [](int index) {
    return _Element(webCollection.item(index)!);
  }

  @override
  void insert(int index, Element element) {
    if (index == length) {
      add(element);
    } else {
      var next = this[index];
      parent.insertBefore(element, next);
    }
  }

  @override
  void add(Element element) {
    parent.append(element);
  }

  @override
  void clear() {
    var list = List<Element>.from(this);
    for (var i = 0; i < list.length; i++) {
      list[i].remove();
    }
  }

  @override
  Element removeAt(int index) {
    var item = itemAt(index);
    item.remove();
    return item;
  }

  @override
  void operator []=(int index, Element value) {
    throw UnsupportedError('read only');
  }
}

mixin _NodeWebMixin implements Node {
  @override
  HtmlProvider get htmlProvider => htmlProviderWeb;

  /// Text content (good for text node)
  @override
  String? get textContent => webNode.textContent;

  @override
  Node appendChild(Node node) {
    webNode.appendChild(node.webNode);
    return node;
  }

  @override
  Node insertBefore(Node newNode, Node referenceNode) {
    return _wrapExceptionSyncAsStateError(() {
      webNode.insertBefore(newNode.webNode, referenceNode.webNode);
      return newNode;
    });
  }

  @override
  Node removeChild(Node child) {
    return _wrapExceptionSyncAsStateError(() {
      return _html.wrapNode(webNode.removeChild(child.webNode));
    });
  }

  T _wrapExceptionSyncAsStateError<T>(T Function() action) {
    try {
      return action();
    } catch (e) {
      throw StateError(e.toString());
    }
  }

  @override
  Node replaceChild(Node newChild, Node oldChild) {
    _wrapExceptionSyncAsStateError(() {
      webNode.replaceChild(newChild.webNode, oldChild.webNode);
    });
    return newChild;
  }

  @override
  int get hashCode => webNode.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is NodeWeb) {
      return webNode == other.webNode;
    }
    return false;
  }
}

/// Web implementation
abstract mixin class _DocumentImplMixin {
  /// Our provider
  HtmlProvider get htmlProvider => _html;
}

class _BodyElement extends _Element implements BodyElement {
  _BodyElement(super.element);
}

class _HeadElement extends _Element implements HeadElement {
  _HeadElement(super.element);
}

class _HtmlElement extends _Element implements HtmlElement {
  _HtmlElement(super.element);
}

extension DocumentWebExt on Document {
  web.Document get webDoc => (this as _Document).webDoc;
}

class _Document extends DocumentBase with DocumentMixin, _DocumentImplMixin {
  final web.Document webDoc;

  _Document(this.webDoc) : super();

  @override
  String get title => webDoc.title;

  @override
  set title(String title) => webDoc.title = title;

  String? outerHtml(int padding) {
    return (webDoc.documentElement!.outerHTML as JSString).toDart;
  }

  @override
  void fixMissing({String title = '', String? charset = attrCharsetUtf8}) {
    // fixing title fail using the default way
    var index = 0;

    if (charset != null) {
      fixNotExistingCharset(index, charset);
      index++;
    }

    //print('title : ${_htmlDoc.title}');
    if (title.isNotEmpty) {
      webDoc.title = title;
    } else {
      if (webDoc.title == '') {
        webDoc.title = title;
      }
    }
    //print('title : ${_htmlDoc.title}');
  }

  @override
  String toString() {
    return '<!DOCTYPE html>${webDoc.documentElement!.outerHTML}';
  }

  @override
  BodyElement get body => _BodyElement(webDoc.body!);

  @override
  HeadElement get head => _HeadElement(webDoc.head!);

  @override
  HtmlElement get html => _HtmlElement(webDoc.documentElement!);
}

class _HtmlProviderWeb implements HtmlProviderWeb {
  @override
  Document createDocument(
      {String html = '',
      String title = '',
      String? charset = attrCharsetUtf8,
      bool noCharsetTitleFix = false}) {
    web.Document webDoc;
    if (html.isNotEmpty) {
      final domParser = web.DOMParser();
      webDoc = domParser.parseFromString(html.toJS, 'text/html');
    } else {
      webDoc = web.document.implementation.createHTMLDocument(title);
    }
    final doc = _Document(webDoc);
    if (!noCharsetTitleFix) {
      doc.fixMissing(title: title, charset: charset);
    }

    return doc;
  }

  @override
  Element createElementHtml(String html, {bool? noValidate}) {
    var div = createElementTag('div');
    div.innerHtml = html.trim();
    return div.children.first;
  }

  @override
  Element createElementTag(String tag) =>
      _Element(web.window.document.createElement(tag));

  @override
  String get name => providerWebName;

  @override
  dynamic unwrapDocument(Document? document) {
    return document?.webDoc;
  }

  @override
  Object unwrapElement(Element element) {
    return element.webNode;
  }

  @override
  Document wrapDocument(documentImpl) {
    return _Document(documentImpl as web.Document);
  }

  @override
  Element wrapElement(elementImpl) {
    return _Element(elementImpl as web.Element);
  }

  @override
  Text createTextNode(String text) {
    return _Text.text(text);
  }

  @override
  Object unwrapNode(Node node) {
    return node.webNode;
  }

  @override
  Node wrapNode(Object? elementImpl) {
    var webNode = elementImpl as web.Node;
    if (webNode.nodeType == web.Node.TEXT_NODE) {
      return _Text.impl(webNode as web.Text);
    } else if (webNode.nodeType == web.Node.ELEMENT_NODE) {
      return _Element(webNode as web.Element);
    } else {
      return _NodeWebBase(webNode);
    }
  }
}

/// Web html provider (js_interop)
HtmlProvider htmlProviderWeb = _HtmlProviderWeb();

final currentHtmlDocumentWeb = htmlProviderWeb.wrapDocument(web.document);

/// Local provider
_HtmlProviderWeb get _html => htmlProviderWeb as _HtmlProviderWeb;

/// Internal Text interface
abstract class _Text implements Text {
  factory _Text.impl(web.Text value) => _TextWeb(value);

  factory _Text.text(String value) => _TextWeb.text(value);
}

class _TextWeb extends _NodeBase with _NodeWebMixin implements _Text {
  /// Non nullable text content
  @override
  String get text => webNode.textContent!;

  _TextWeb(super.webNode);

  _TextWeb.text(String value) : super(web.Text(value));

  @override
  String toString() => 'Text($text)';
}
