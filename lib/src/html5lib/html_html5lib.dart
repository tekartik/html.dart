// ignore_for_file: provide_deprecation_message

library;

import 'package:html/dom.dart' as html5lib;
import 'package:tekartik_html/attr.dart';
import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/src/html5lib/css_class_set.dart';
import 'package:tekartik_html/src/html5lib/data_set.dart';
import 'package:tekartik_html/src/html_base.dart';
import 'package:tekartik_html/tag.dart';

class _Node extends Node with _NodeImpl {
  _Node.impl(html5lib.Node node) {
    _node = node;
  }
}

abstract mixin class _NodeImpl extends Object {
  late html5lib.Node _node;

  html5lib.Element get _element =>
      _node as html5lib.Element; // only work if element
  set _element(html5lib.Element element) => _node = element;

  int get nodeType => _node.nodeType;

  String? get nodeValue => _node.text;
}

Node _newNodeFrom(html5lib.Node node) {
  if (node is html5lib.Element) {
    return _Element.impl(node);
  } else {
    return _Node.impl(node);
  }
}

class _ElementList extends ElementList {
  final List<html5lib.Element> _list;

  _ElementList(this._list);

  @override
  Element operator [](int index) {
    return _Element.impl(_list[index]);
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

class _Element extends Element with _ElementImpl, _NodeImpl {
  _Element.impl(html5lib.Element element) {
    _element = element;
  }
}

abstract mixin class _ElementImpl {
  html5lib.Element get _element;

  ElementList get children => _ElementList(_element.children);

  String get id => _element.id;

  set id(String id) {
    _element.id = id;
  }

  String get tagName => _element.localName!;

  Element? getElementById(String id) {
    for (final child in children) {
      if (child.id == id) {
        return child;
      }
    }
    return null;
  }

  static Element? from(html5lib.Element? element) {
    if (element == null) {
      return null;
    }

    return _Element.impl(element);
  }

  String get outerHtml => _element.outerHtml;

  String get innerHtml => _element.innerHtml;

  set innerHtml(String html) {
    _element.innerHtml = html;
  }

  String get text => _element.text;

  set text(String text) => _element.text = text;

  Element? querySelector(String selector) {
    return from(_element.querySelector(selector));
  }

  ElementList querySelectorAll(String selector) {
    return _ElementList(_element.querySelectorAll(selector));
  }

  static bool tagsEquals(String? tag1, String? tag2) {
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
      final classes = element.attributes[attrClass];

      if (classes == null) {
        return false;
      }

      if (!classes.trim().split(' ').contains(criteria.byClass)) {
        return false;
      }
    }

    if (criteria.byAttributes != null) {
      var found = false;
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

  static html5lib.Element? _queryChild(
      html5lib.Element parent, QueryCriteria criteria) {
    for (var node in parent.nodes) {
      if (node is html5lib.Element) {
        if (_matches(node, criteria)) {
          return node;
        }

        // Go deeper
        if (criteria.recursive) {
          final found = _queryChild(node, criteria);
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
    final list = <html5lib.Element>[];
    for (var node in parent.nodes) {
      if (node is html5lib.Element) {
        if (_matches(node, criteria)) {
          list.add(node);
        }

        // Go deeper
        if (criteria.recursive) {
          list.addAll(_queryChildren(node, criteria));
        }
      }
    }

    return list;
  }

  //@override
  Element? queryCriteria(QueryCriteria criteria) {
    return from(_queryChild(_element, criteria));
  }

  //@override
  ElementList queryCriteriaAll(QueryCriteria criteria) {
    return _ElementList(_queryChildren(_element, criteria));
  }

  Element? query(
      {String? byTag, String? byId, String? byClass, String? byAttributes}) {
    return queryCriteria(QueryCriteria(
        byTag: byTag,
        byId: byId,
        byClass: byClass,
        byAttributes: byAttributes));
  }

  ElementList queryAll(
      {String? byTag, String? byId, String? byClass, String? byAttributes}) {
    return queryCriteriaAll(QueryCriteria(
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

  CssClassSet get classes => CssClassSetImpl(_element.attributes);

  //@override
  Map<Object, String> get attributes => _element.attributes;

  //@override
  void remove() {
    _element.remove();
  }

  //@override
  Element? get parent => from(_element.parent);

  //@override
  DataSet get dataset => DataSetHtml5lib(_element.attributes);

//@override
  List<Node> get childNodes {
    final children = <Node>[];
    for (final node in _element.nodes) {
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

  Element? get nextElementSibling => from(_element.nextElementSibling);

  void dummyTest() {
    //_element.children
    //_element.insertBefore(node, refNode)
    _element.nextElementSibling;
  }

  @override
  String toString() {
    return _element.toString();
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

abstract mixin class _DocumentImpl {
  // html5lib.Document get _document;

  static Document? from(html5lib.Document? documentImpl) {
    if (documentImpl == null) {
      return null;
    }

    return _Document(documentImpl);
  }
}

class _Document extends DocumentBase with DocumentMixin, _DocumentImpl {
  final html5lib.Document _document;

  _Document(this._document) : super(_html);

  Element? get _titleElement {
    for (var i = 0; i < head.children.length; i++) {
      final element = head.children[i];
      //print(element.outerHtml);
      if (element.tagName == tagTitle) {
        return element;
      }
    }
    return null;
  }

  @override
  String get title {
    final titleElement = _titleElement;
    if (titleElement != null) {
      return titleElement.text;
    } else {
      return '';
    }
  }

  @override
  set title(String title) {
    final titleElement = _titleElement;
    if (titleElement != null) {
      titleElement.text = title;
    } else {
      // insert at the top
      // we should not get there that often though
      head.children
          .insert(0, provider.createElementTag(tagTitle)..text = title);
    }
  }

  String outerHtml(int padding) {
    return _document.outerHtml;
  }

  @override
  String toString() {
    return _document.outerHtml;
  }

  void _fixNotExistingTitle(int index, String title) {
    //print(head.outerHtml);
    final titleElement = _titleElement;
    if (titleElement != null) {
      if (title.isNotEmpty) {
        if (titleElement.text != title) {
          titleElement.text = title;
        }
      }
      return;
    }
    head.children
        .insert(index, provider.createElementTag(tagTitle)..text = title);
  }

  @override
  void fixMissing({String title = '', String? charset = attrCharsetUtf8}) {
    var index = 0;

    if (charset != null) {
      fixNotExistingCharset(index, charset);
      index++;
    }

    _fixNotExistingTitle(index, title);
  }

  void _fixMissingDocumentType() {
    for (var i = 0; i < _document.nodes.length; i++) {
      final node = _document.nodes[i];
      if (node is html5lib.DocumentType) {
        return;
      }
    }
    html5lib.Node docType = html5lib.DocumentType('html', null, null);
    _document.nodes.insert(0, docType);
  }

  @override
  BodyElement get body => _BodyElement(_document.body!);

  @override
  HeadElement get head => _HeadElement(_document.head!);

  @override
  HtmlElement get html => _HtmlElement(_document.documentElement!);
}

class _HtmlProviderHtml5Lib extends HtmlProvider {
  @override
  Document createDocument(
      {String html = '',
      String title = '',
      String? charset = attrCharsetUtf8,
      bool noCharsetTitleFix = false}) {
    html5lib.Document doc;
    doc = html5lib.Document.html(html);

    final htmlDoc = _Document(doc);

    if (!noCharsetTitleFix) {
      htmlDoc.fixMissing(title: title, charset: charset);
    }
    htmlDoc._fixMissingDocumentType();

    return htmlDoc;
  }

  @override
  Element createElementTag(String tag) {
    return _ElementImpl.from(html5lib.Element.tag(tag))!;
  }

  @override
  Element createElementHtml(String html, {bool? noValidate}) {
    // noValidate is implicit when using html5 lib
    return _ElementImpl.from(html5lib.Element.html(html))!;
  }

  @override
  String get name => providerHtml5LibName;

  // return the html element wrapper
  @override
  Element? wrapElement(/*html5lib.Element*/ htmlElement) =>
      _ElementImpl.from(htmlElement as html5lib.Element?);

  // return the html5lib implementation
  @override
  html5lib.Element? unwrapElement(Element? element) =>
      (element as _Element)._element;

  // wrap a native document
  @override
  Document wrapDocument(/*html5lib.Document*/ documentImpl) =>
      _DocumentImpl.from(documentImpl as html5lib.Document)!;

  // get the native native document
  @override
  html5lib.Document unwrapDocument(Document? document) =>
      (document as _Document)._document;
}

_HtmlProviderHtml5Lib get _html =>
    htmlProviderHtml5Lib as _HtmlProviderHtml5Lib;

/// Safe to be called multiple times
@deprecated
HtmlProvider initHtmlProvider() {
  return _html;
}

HtmlProvider htmlProviderHtml5Lib = _HtmlProviderHtml5Lib();
