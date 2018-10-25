library html_browser;

import 'dart:html' as dart_html;
import 'html.dart';
import 'attr.dart';
part 'src/browser/css_class_set.dart';
part 'src/browser/data_set.dart';

class _NullTreeSanitizer implements dart_html.NodeTreeSanitizer {
  void sanitizeTree(node) {}
}

class _ElementList extends ElementList {
  List<dart_html.Element> _list;
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
  void add(Element element_) {
    _list.add((element_ as _ElementImpl)._element);
  }

  @override
  void insert(int index, Element element_) {
    _list.insert(index, (element_ as _ElementImpl)._element);
  }

  @override
  Element removeAt(int index) {
    return _ElementImpl.from(_list.removeAt(index));
  }

  @override
  bool remove(Element element_) {
    return _list.remove((element_ as _ElementImpl)._element);
  }

  @override
  int indexOf(Element element_) {
    return _list.indexOf((element_ as _ElementImpl)._element);
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

abstract class _NodeImpl extends Object {
  dart_html.Node _node;
  dart_html.Element get _element =>
      _node as dart_html.Element; // only work if element
  set _element(dart_html.Element element) => _node = element;

  int get nodeType => _node.nodeType;
  String get nodeValue => _node.nodeValue;
}

Node _newNodeFrom(dart_html.Node _node) {
  if (_node is dart_html.Element) {
    return _Element._(_node);
  } else {
    return _Node._(_node);
  }
}

class _Element extends Element with _ElementImpl, _NodeImpl {
  _Element._(dart_html.Element element) {
    _element = element;
  }
  _Element.tag(String tag) {
    _element = dart_html.Element.tag(tag);
  }
}

abstract class _ElementImpl extends Object {
  set _element(dart_html.Element element);
  dart_html.Element get _element;
  ElementList get children => _ElementList(_element.children);
  Element getElementById(String id) {
    return from(_element.querySelector('#$id'));
  }

  String get id => _element.id;
  void set id(String id_) {
    _element.id = id_;
  }

  String get tagName => _element.tagName.toLowerCase();

  static Element from(dart_html.Element element_) {
    if (element_ == null) {
      return null;
    }
    return _Element._(element_);
  }

  String get outerHtml => _element.outerHtml;
  String get innerHtml => _element.innerHtml;
  void set innerHtml(String html) {
    _element.innerHtml = html;
  }

  String get text => _element.text;
  set text(String text) => _element.text = text;

  Element querySelector(String selector) {
    return from(_element.querySelector(selector));
  }

  ElementList querySelectorAll(String selector) {
    return _ElementList(_element.querySelectorAll(selector));
  }

  static String _buildSelector(
      {String byTag, String byId, String byClass, String byAttributes}) {
    StringBuffer sb = StringBuffer();
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
    StringBuffer sb = StringBuffer();
    if (criteria.recursive == false) {
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
  Element queryCriteria(QueryCriteria criteria) {
    return querySelector(_buildCriteriaSelector(criteria));
  }

  //@override
  ElementList queryCriteriaAll(QueryCriteria criteria) {
    return querySelectorAll(_buildCriteriaSelector(criteria));
  }

  Element query(
      {String byTag, String byId, String byClass, String byAttributes}) {
    return querySelector(_buildSelector(
        byTag: byTag,
        byId: byId,
        byClass: byClass,
        byAttributes: byAttributes));
  }

  ElementList queryAll(
      {String byTag, String byId, String byClass, String byAttributes}) {
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
  Element get parent => from(_element.parent);

  //@override
  DataSet get dataset => DataSetBrowser(_element.dataset);

  //@override
  List<Node> get childNodes {
    List<Node> children = [];
    for (dart_html.Node node in _element.childNodes) {
      if (node is dart_html.Element) {}
      children.add(_newNodeFrom(node));
    }
    return children;
  }

  //@override
  Node append(Node node) {
    _element.append((node as _NodeImpl)._node);
    return node;
  }

  //@override
  void insertBefore(Node node, Node refNode) {
    _element.insertBefore(
        (node as _NodeImpl)._node, (refNode as _NodeImpl)._node);
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
  dart_html.BodyElement get bodyElement => _element as dart_html.BodyElement;
  _BodyElement(dart_html.BodyElement body) {
    _element = body;
  }
}

class _HeadElement extends HeadElement with _ElementImpl, _NodeImpl {
  dart_html.HeadElement get headElement => _element as dart_html.HeadElement;
  _HeadElement(dart_html.HeadElement head) {
    _element = head;
  }
}

class _HtmlElement extends HtmlElement with _ElementImpl, _NodeImpl {
  dart_html.HtmlElement get htmlElement => _element as dart_html.HtmlElement;
  _HtmlElement(dart_html.HtmlElement html) {
    _element = html;
  }
}

abstract class _DocumentImpl {
  dart_html.HtmlDocument get _htmlDoc;
  static Document from(dart_html.HtmlDocument htmlDoc) {
    if (htmlDoc == null) {
      return null;
    }

    return _Document(htmlDoc);
  }
}

class _Document extends Document with _DocumentImpl {
  dart_html.HtmlDocument _htmlDoc;
  _Document(this._htmlDoc) : super(_html);

  String get title => _htmlDoc.title;
  set title(String title) => _htmlDoc.title = title;

  String outerHtml(int padding) {
    return _htmlDoc.documentElement.outerHtml;
  }

  void fixMissing({String title = '', String charset = CHARSET_UTF_8}) {
    // fixing title fail using the default way
    int index = 0;

    if (charset != null) {
      fixNotExistingCharset(index, charset);
      index++;
    }

    //print('title : ${_htmlDoc.title}');
    if (title.length > 0) {
      _htmlDoc.title = title;
    } else {
      if (_htmlDoc.title == null) {
        _htmlDoc.title = title;
      } else if (_htmlDoc.title == '') {
        _htmlDoc.title = title;
      }
    }
    //print('title : ${_htmlDoc.title}');
  }

  @override
  String toString() {
    return '<!DOCTYPE html>${_htmlDoc.documentElement.outerHtml}';
  }

  BodyElement get body => _BodyElement(_htmlDoc.body);
  HeadElement get head => _HeadElement(_htmlDoc.head);
  HtmlElement get html =>
      _HtmlElement(_htmlDoc.documentElement as dart_html.HtmlElement);
}

class _HtmlProviderBrowser extends HtmlProvider {
  Document createDocument(
      {String html = '',
      String title = '',
      String charset = CHARSET_UTF_8,
      bool noCharsetTitleFix = false}) {
    dart_html.HtmlDocument htmlDoc;
    if (html.length > 0) {
      dart_html.DomParser domParser = dart_html.DomParser();
      htmlDoc = domParser.parseFromString(html, "text/html")
          as dart_html.HtmlDocument;
    } else {
      htmlDoc = dart_html.document.implementation.createHtmlDocument(title);
    }

    _Document doc = _Document(htmlDoc);
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

  Element createElementTag(String tag) {
    return _ElementImpl.from(dart_html.Element.tag(tag));
  }

  static _NullTreeSanitizer nullTreeSanitizer = _NullTreeSanitizer();

  @override
  Element createElementHtml(String html, {bool noValidate}) {
    dart_html.NodeTreeSanitizer sanitizer;
    if (noValidate == true) {
      sanitizer = nullTreeSanitizer;
    }
    return _ElementImpl.from(
        dart_html.Element.html(html, treeSanitizer: sanitizer));
  }

  String get name => providerBrowserName;

  // return the html element wrapper
  Element wrapElement(/*dart_html.Element */ _element) =>
      _ElementImpl.from(_element as dart_html.Element);

  // return the html5lib implementation
  dart_html.Element unwrapElement(Element element) =>
      (element as _Element)._element;

  // return the html element wrapper
  Document wrapDocument(/*dart_html.Document*/ _document) =>
      _DocumentImpl.from(_document as dart_html.HtmlDocument);

  // return the html5lib implementation
  dart_html.Document unwrapDocument(/*_Document*/ document) =>
      (document as _Document)._htmlDoc;
}

_HtmlProviderBrowser get _html => htmlProviderBrowser as _HtmlProviderBrowser;

@deprecated
HtmlProvider initHtmlProvider() {
  return _html;
}

HtmlProvider htmlProviderBrowser = _HtmlProviderBrowser();
