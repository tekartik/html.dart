// ignore_for_file: provide_deprecation_message

library html_browser;

import 'dart:html' as dart_html;

import 'package:tekartik_html/src/browser/css_class_set.dart';
import 'package:tekartik_html/src/browser/data_set.dart';

import 'attr.dart';
import 'html.dart';

class _NullTreeSanitizer implements dart_html.NodeTreeSanitizer {
  @override
  void sanitizeTree(node) {}
}

class _ElementList extends ElementList {
  final List<dart_html.Element?> _list;

  _ElementList(this._list);

  @override
  Element operator [](int index) {
    return _Element._(_list[index]);
  }

  @override
  void operator []=(int index, Element value) {
    _list[index] = (value as _Element)._element;
  }

  @override
  int get length => _list.length;

  @override
  void add(Element element) {
    _list.add((element as _ElementImpl)._element);
  }

  @override
  void insert(int index, Element element) {
    _list.insert(index, (element as _ElementImpl)._element);
  }

  @override
  Element? removeAt(int index) {
    return _ElementImpl.from(_list.removeAt(index));
  }

  @override
  bool remove(Element element) {
    return _list.remove((element as _ElementImpl)._element);
  }

  @override
  int indexOf(Element element) {
    return _list.indexOf((element as _ElementImpl)._element);
  }

  @override
  void clear() {
    _list.clear();
  }
}

class _Node extends Node with _NodeImpl {
  _Node._(dart_html.Node node) {
    _node = node;
  }
}

mixin class _NodeImpl extends Object {
  dart_html.Node? _node;

  dart_html.Element get _element =>
      _node as dart_html.Element; // only work if element
  set _element(dart_html.Element? element) => _node = element;

  int get nodeType => _node!.nodeType;

  String? get nodeValue => _node!.nodeValue;
}

Node _newNodeFrom(dart_html.Node htmlNode) {
  if (htmlNode is dart_html.Element) {
    return _Element._(htmlNode);
  } else {
    return _Node._(htmlNode);
  }
}

class _Element extends Element with _ElementImpl, _NodeImpl {
  _Element._(dart_html.Element? element) {
    _element = element;
  }
}

abstract mixin class _ElementImpl extends Object {
  //set _element(dart_html.Element element);

  dart_html.Element get _element;

  ElementList get children => _ElementList(_element.children);

  Element? getElementById(String id) {
    return from(_element.querySelector('#$id'));
  }

  String get id => _element.id;

  set id(String id) {
    _element.id = id;
  }

  String get tagName => _element.tagName.toLowerCase();

  static Element? from(dart_html.Element? element) {
    if (element == null) {
      return null;
    }
    return _Element._(element);
  }

  String get outerHtml => _element.outerHtml!;

  String get innerHtml => _element.innerHtml!;

  set innerHtml(String? html) {
    _element.innerHtml = html;
  }

  String get text => _element.text ?? '';

  set text(String text) => _element.text = text;

  Element? querySelector(String selector) {
    return from(_element.querySelector(selector));
  }

  ElementList querySelectorAll(String selector) {
    return _ElementList(_element.querySelectorAll(selector));
  }

  static String _buildSelector(
      {String? byTag, String? byId, String? byClass, String? byAttributes}) {
    final sb = StringBuffer();
    if (byTag != null) {
      sb.write(byTag);
    }
    if (byId != null) {
      sb.write('#$byId');
    }

    if (byClass != null) {
      sb.write('.$byClass');
    }
    if (byAttributes != null) {
      sb.write('[$byAttributes]');
    }

    return sb.toString();
  }

  static String _buildCriteriaSelector(QueryCriteria criteria) {
    final sb = StringBuffer();
    if (!criteria.recursive) {
      sb.write(':scope > ');
    }
    if (criteria.byTag != null) {
      sb.write(criteria.byTag);
    }
    if (criteria.byId != null) {
      sb.write('#${criteria.byId}');
    }

    if (criteria.byClass != null) {
      sb.write('.${criteria.byClass}');
    }
    if (criteria.byAttributes != null) {
      sb.write('[${criteria.byAttributes}]');
    }

    return sb.toString();
  }

  //@override
  Element? queryCriteria(QueryCriteria criteria) {
    return querySelector(_buildCriteriaSelector(criteria));
  }

  //@override
  ElementList queryCriteriaAll(QueryCriteria criteria) {
    return querySelectorAll(_buildCriteriaSelector(criteria));
  }

  Element? query(
      {String? byTag, String? byId, String? byClass, String? byAttributes}) {
    return querySelector(_buildSelector(
        byTag: byTag,
        byId: byId,
        byClass: byClass,
        byAttributes: byAttributes));
  }

  ElementList queryAll(
      {String? byTag, String? byId, String? byClass, String? byAttributes}) {
    return querySelectorAll(_buildSelector(
        byTag: byTag,
        byId: byId,
        byClass: byClass,
        byAttributes: byAttributes));
  }

  // Support for equals
  @override
  int get hashCode {
    return _element.hashCode;
  }

  // You should generally implement operator== if you override hashCode.
  @override
  bool operator ==(other) {
    if (other is _Element) {
      return _element == other._element;
    }
    return false;
  }

  //TODO optimize
  CssClassSet get classes => CssClassSetBrowser(_element.classes);

  //@override
  void remove() {
    _element.remove();
  }

  //@override
  Map<dynamic, String> get attributes => _element.attributes;

  //@override
  Element? get parent => from(_element.parent);

  //@override
  DataSet get dataset => DataSetBrowser(_element.dataset);

  //@override
  List<Node> get childNodes {
    final children = <Node>[];
    for (final node in _element.childNodes) {
      if (node is dart_html.Element) {}
      children.add(_newNodeFrom(node));
    }
    return children;
  }

  //@override
  Node append(Node node) {
    _element.append((node as _NodeImpl)._node!);
    return node;
  }

  //@override
  void insertBefore(Node node, Node refNode) {
    _element.insertBefore(
        (node as _NodeImpl)._node!, (refNode as _NodeImpl)._node);
  }

  @override
  String toString() {
    return _element.toString();
  }

  void dummyTest() {
    //    _element.dataset
    //_element.que
    //_element.remove();
    //_element.parent
    //_element.append
    //_element.ins
  }
}

class _BodyElement extends BodyElement with _ElementImpl, _NodeImpl {
  dart_html.BodyElement? get bodyElement => _element as dart_html.BodyElement?;

  _BodyElement(dart_html.BodyElement? body) {
    _element = body;
  }
}

class _HeadElement extends HeadElement with _ElementImpl, _NodeImpl {
  dart_html.HeadElement? get headElement => _element as dart_html.HeadElement?;

  _HeadElement(dart_html.HeadElement? head) {
    _element = head;
  }
}

class _HtmlElement extends HtmlElement with _ElementImpl, _NodeImpl {
  dart_html.HtmlElement? get htmlElement => _element as dart_html.HtmlElement?;

  _HtmlElement(dart_html.HtmlElement? html) {
    _element = html;
  }
}

abstract mixin class _DocumentImpl {
  //dart_html.HtmlDocument get _htmlDoc;

  static Document? from(dart_html.HtmlDocument? htmlDoc) {
    if (htmlDoc == null) {
      return null;
    }

    return _Document(htmlDoc);
  }
}

class _Document extends Document with _DocumentImpl {
  final dart_html.HtmlDocument _htmlDoc;

  _Document(this._htmlDoc) : super(_html);

  @override
  String get title => _htmlDoc.title;

  @override
  set title(String title) => _htmlDoc.title = title;

  String? outerHtml(int padding) {
    return _htmlDoc.documentElement!.outerHtml;
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
      _htmlDoc.title = title;
    } else {
      if (_htmlDoc.title == '') {
        _htmlDoc.title = title;
      }
    }
    //print('title : ${_htmlDoc.title}');
  }

  @override
  String toString() {
    return '<!DOCTYPE html>${_htmlDoc.documentElement!.outerHtml}';
  }

  @override
  BodyElement get body => _BodyElement(_htmlDoc.body);

  @override
  HeadElement get head => _HeadElement(_htmlDoc.head);

  @override
  HtmlElement get html =>
      _HtmlElement(_htmlDoc.documentElement as dart_html.HtmlElement?);
}

class _HtmlProviderBrowser extends HtmlProvider {
  @override
  Document createDocument(
      {String html = '',
      String title = '',
      String? charset = attrCharsetUtf8,
      bool noCharsetTitleFix = false}) {
    dart_html.HtmlDocument htmlDoc;
    if (html.isNotEmpty) {
      final domParser = dart_html.DomParser();
      htmlDoc = domParser.parseFromString(html, 'text/html')
          as dart_html.HtmlDocument;
    } else {
      htmlDoc = dart_html.document.implementation!.createHtmlDocument(title);
    }

    final doc = _Document(htmlDoc);
    //print(doc);
    //   _Document doc = new _Document(
    //        dart_html.document.implementation.createHtmlDocument(title));
    //
    //    if (html.length > 0) {
    //      print(doc._htmlDoc.documentElement.innerHtml);
    //      print(html);
    //      doc._htmlDoc.documentElement.innerHtml = html;
    //      print(doc._htmlDoc.documentElement.innerHtml);
    //    }
    //    new dart_html.DomParser
    if (!noCharsetTitleFix) {
      doc.fixMissing(title: title, charset: charset);
    }

    return doc;
  }

  @override
  Element createElementTag(String tag) {
    return _ElementImpl.from(dart_html.Element.tag(tag))!;
  }

  static _NullTreeSanitizer nullTreeSanitizer = _NullTreeSanitizer();

  @override
  Element createElementHtml(String html, {bool? noValidate}) {
    dart_html.NodeTreeSanitizer? sanitizer;
    if (noValidate == true) {
      sanitizer = nullTreeSanitizer;
    }
    return _ElementImpl.from(
        // ignore: unsafe_html
        dart_html.Element.html(html, treeSanitizer: sanitizer))!;
  }

  @override
  String get name => providerBrowserName;

  // return the html element wrapper
  @override
  Element? wrapElement(/*dart_html.Element */ htmlElement) =>
      _ElementImpl.from(htmlElement as dart_html.Element?);

  // return the html5lib implementation
  @override
  dart_html.Element? unwrapElement(Element? element) =>
      (element as _Element)._element;

  // return the html element wrapper
  @override
  Document wrapDocument(/*dart_html.Document*/ htmlDocument) =>
      _DocumentImpl.from(htmlDocument as dart_html.HtmlDocument)!;

  // return the html5lib implementation
  @override
  dart_html.Document unwrapDocument(/*_Document*/ document) =>
      (document as _Document)._htmlDoc;
}

_HtmlProviderBrowser get _html => htmlProviderBrowser as _HtmlProviderBrowser;

@deprecated
HtmlProvider initHtmlProvider() {
  return _html;
}

HtmlProvider htmlProviderBrowser = _HtmlProviderBrowser();
