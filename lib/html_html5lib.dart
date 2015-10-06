library html_html5lib;

import 'package:html/dom.dart' as html5lib;
import 'html.dart';
import 'attr.dart';
import 'tag.dart';

part 'src/html5lib/css_class_set.dart';
part 'src/html5lib/data_set.dart';

class _Node extends Node with _NodeImpl {
  _Node.impl(html5lib.Node node) {
    _node = node;
  }
}

abstract class _NodeImpl extends Object {
  html5lib.Node _node;
  html5lib.Element get _element => _node; // only work if element
  set _element(html5lib.Element element) => _node = element;

  int get nodeType => _node.nodeType;
  String get nodeValue => _node.text;
}

Node _newNodeFrom(html5lib.Node _node) {
  if (_node is html5lib.Element) {
    return new _Element.impl(_node);
  } else {
    return new _Node.impl(_node);
  }
}

class _ElementList extends ElementList {
  List<html5lib.Element> _list;
  _ElementList(this._list);
  @override
  Element operator [](int index) {
    return new _Element.impl(_list[index]);
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
}

class _Element extends Element with _ElementImpl, _NodeImpl {
  _Element.impl(html5lib.Element element) {
    _element = element;
  }
}

abstract class _ElementImpl {
  html5lib.Element get _element;
  ElementList get children => new _ElementList(_element.children);
  String get id => _element.id;
  void set id(String id_) {
    _element.id = id_;
  }

  String get tagName => _element.localName;
  Element getElementById(String id) {
    for (Element child in children) {
      if (child.id == id) {
        return child;
      }
    }
    return null;
  }

  static Element from(html5lib.Element element_) {
    if (element_ == null) {
      return null;
    }

    return new _Element.impl(element_);
  }

  String get outerHtml => _element.outerHtml;
  String get innerHtml => _element.innerHtml;
  void set innerHtml(String html) {
    _element.innerHtml = html;
  }

  Element querySelector(String selector) {
    return from(_element.querySelector(selector));
  }

  ElementList querySelectorAll(String selector) {
    return new _ElementList(_element.querySelectorAll(selector));
  }

  static bool tagsEquals(String tag1, String tag2) {
    if (tag1 != null) {
      if (tag2 != null) {
        return tag1.toLowerCase() == tag2.toLowerCase();
      }
      return false;
    } else {
      return (tag2 == null);
    }
  }

  static bool _matches(html5lib.Element element, QueryCriteria criteria) {
    if (criteria.byTag != null) {
      if (!tagsEquals(element.localName, criteria.byTag)) {
        return false;
      }
    }

    if (criteria.byId != null) {
      if (element.id != criteria.byId) {
        return false;
      }
    }

    if (criteria.byClass != null) {
      String classes = element.attributes[CLASS];

      if (classes == null) {
        return false;
      }

      if (!classes.trim().split(' ').contains(criteria.byClass)) {
        return false;
      }
    }

    if (criteria.byAttributes != null) {
      bool found = false;
      for (var key in element.attributes.keys) {
        if (key is String) {
          if (key == criteria.byAttributes) {
            found = true;
            break;
          }
        }
      }
      if (!found) {
        return false;
      }
    }

    return true;
  }

  static html5lib.Element _queryChild(
      html5lib.Element parent, QueryCriteria criteria) {
    for (var node in parent.nodes) {
      if (node is html5lib.Element) {
        if (_matches(node, criteria)) {
          return node;
        }

        // Go deeper
        if (criteria.recursive != false) {
          html5lib.Element found = _queryChild(node, criteria);
          if (found != null) {
            return found;
          }
        }
      }
    }

    return null;
  }

  static List<html5lib.Element> _queryChildren(
      html5lib.Element parent, QueryCriteria criteria) {
    List<html5lib.Element> list = new List();
    for (var node in parent.nodes) {
      if (node is html5lib.Element) {
        if (_matches(node, criteria)) {
          list.add(node);
        }

        // Go deeper
        if (criteria.recursive != false) {
          list.addAll(_queryChildren(node, criteria));
        }
      }
    }

    return list;
  }

  //@override
  Element queryCriteria(QueryCriteria criteria) {
    return from(_queryChild(_element, criteria));
  }

  //@override
  ElementList queryCriteriaAll(QueryCriteria criteria) {
    return new _ElementList(_queryChildren(_element, criteria));
  }

  Element query(
      {String byTag, String byId, String byClass, String byAttributes}) {
    return queryCriteria(new QueryCriteria(
        byTag: byTag,
        byId: byId,
        byClass: byClass,
        byAttributes: byAttributes));
  }

  ElementList queryAll(
      {String byTag, String byId, String byClass, String byAttributes}) {
    return queryCriteriaAll(new QueryCriteria(
        byTag: byTag,
        byId: byId,
        byClass: byClass,
        byAttributes: byAttributes));
  }

  // Support for equals
  int get hashCode {
    return _element.hashCode;
  }

  // You should generally implement operator== if you override hashCode.
  bool operator ==(other) {
    if (other is _Element) {
      return _element == other._element;
    }
    return false;
  }

  CssClassSet get classes => new CssClassSetImpl(_element.attributes);

  //@override
  Map<dynamic, String> get attributes => _element.attributes;

  //@override
  void remove() {
    _element.remove();
  }

  //@override
  Element get parent => from(_element.parent);

  //@override
  DataSet get dataset => new DataSetHtml5lib(_element.attributes);

//@override
  List<Node> get childNodes {
    List<Node> children = [];
    for (html5lib.Node node in _element.nodes) {
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

  Element get nextElementSibling => from(_element.nextElementSibling);

  void dummyTest() {
    //_element.children
    //_element.insertBefore(node, refNode)
    _element.nextElementSibling;
  }
}

class _BodyElement extends BodyElement with _ElementImpl, _NodeImpl {
  _BodyElement(html5lib.Element body) {
    _element = body;
  }
}

class _HeadElement extends HeadElement with _ElementImpl, _NodeImpl {
  _HeadElement(html5lib.Element head) {
    _element = head;
  }
}

class _HtmlElement extends HtmlElement with _ElementImpl, _NodeImpl {
  _HtmlElement(html5lib.Element html) {
    _element = html;
  }
}

class _Document extends Document {
  html5lib.Document _doc;
  _Document(this._doc) : super(_html);
  String outerHtml(int padding) {
    return _doc.outerHtml;
  }

  @override
  String toString() {
    return _doc.outerHtml;
  }

  void _fixNotExistingTitle(int index, String title) {
    //print(head.outerHtml);

    for (int i = 0; i < head.children.length; i++) {
      Element element = head.children[i];
      //print(element.outerHtml);
      if (element.tagName == TITLE) {
        if (title.length > 0) {
          if (element.innerHtml != title) {
            element.innerHtml = title;
          }
        }
        return;
      }
    }
    head.children
        .insert(index, provider.createElementTag(TITLE)..innerHtml = title);
  }

  void fixMissing({String title: '', String charset: CHARSET_UTF_8}) {
    int index = 0;

    if (charset != null) {
      fixNotExistingCharset(index, charset);
      index++;
    }

    _fixNotExistingTitle(index, title);
  }

  void _fixMissingDocumentType() {
    for (int i = 0; i < _doc.nodes.length; i++) {
      html5lib.Node node = _doc.nodes[i];
      if (node is html5lib.DocumentType) {
        return;
      }
    }
    html5lib.Node docType = new html5lib.DocumentType('html', null, null);
    _doc.nodes.insert(0, docType);
  }

  BodyElement get body => new _BodyElement(_doc.body);
  HeadElement get head => new _HeadElement(_doc.head);
  HtmlElement get html => new _HtmlElement(_doc.documentElement);
}

class _HtmlProviderHtml5Lib extends HtmlProvider {
  Document createDocument(
      {String html: '',
      String title: '',
      String charset: CHARSET_UTF_8,
      bool noCharsetTitleFix: false}) {
    html5lib.Document doc;
    doc = new html5lib.Document.html(html);

    _Document _doc = new _Document(doc);

    if (!noCharsetTitleFix) {
      _doc.fixMissing(title: title, charset: charset);
    }
    _doc._fixMissingDocumentType();

    return _doc;
  }

  Element createElementTag(String tag) {
    return _ElementImpl.from(new html5lib.Element.tag(tag));
  }

  Element createElementHtml(String html, {bool noValidate}) {
    // noValidate is implicit when using html5 lib
    return _ElementImpl.from(new html5lib.Element.html(html));
  }

  String get name => PROVIDER_HTML5LIB_NAME;
}

_HtmlProviderHtml5Lib get _html => htmlProviderHtml5Lib;

/**
 * Safe to be called multiple times
 */
@deprecated
HtmlProvider initHtmlProvider() {
  return _html;
}

HtmlProvider htmlProviderHtml5Lib = new _HtmlProviderHtml5Lib();
