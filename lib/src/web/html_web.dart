import 'dart:collection';

import 'package:tekartik_html/attr.dart';
import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/src/common_utils.dart';
import 'package:tekartik_html/src/html_base.dart';
import 'package:web/web.dart' as web;

import 'attributes_web.dart';
import 'css_class_set_web.dart';
import 'data_set_web.dart';

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

class _Node extends _NodeBase with _NodeImpl implements Node {
  _Node(super.node);
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

class _Element extends _NodeBase with _ElementImpl implements Element {
  _Element(web.Element super.element);
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
  String get innerHtml => webElement.innerHTML;

  @override
  set innerHtml(String html) {
    webElement.innerHTML = html;
  }

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
    return List<Node>.generate(
        childNodes.length, (index) => _Node(childNodes.item(index)!));
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
  void insertBefore(Node node, Node refNode) {
    webElement.insertBefore(node.webNode, refNode.webNode);
  }

  @override
  String get outerHtml => webElement.outerHTML;

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

  @override
  int get hashCode => webElement.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is _Element) {
      return webElement == other.webElement;
    }
    return super == other;
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
  void operator []=(int index, Element value) {
    throw UnsupportedError('read only');
  }
}

mixin _NodeImpl {}

abstract mixin class _DocumentImpl {}

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

class _Document extends DocumentBase with DocumentMixin, _DocumentImpl {
  final web.Document webDoc;

  _Document(this.webDoc) : super(htmlProviderWeb);

  @override
  String get title => webDoc.title;

  @override
  set title(String title) => webDoc.title = title;

  String? outerHtml(int padding) {
    return webDoc.documentElement!.outerHTML;
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

class _HtmlProviderWeb implements HtmlProvider {
  @override
  Document createDocument(
      {String html = '',
      String title = '',
      String? charset = attrCharsetUtf8,
      bool noCharsetTitleFix = false}) {
    web.Document webDoc;
    if (html.isNotEmpty) {
      final domParser = web.DOMParser();
      webDoc = domParser.parseFromString(html, 'text/html');
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
  dynamic unwrapElement(Element? element) {
    return element?.webNode;
  }

  @override
  Document wrapDocument(documentImpl) {
    return _Document(documentImpl as web.Document);
  }

  @override
  Element? wrapElement(elementImpl) {
    return _wrapWebElementOrNull(elementImpl as web.Element);
  }
}

/// Web html provider (js_interop)
HtmlProvider htmlProviderWeb = _HtmlProviderWeb();
