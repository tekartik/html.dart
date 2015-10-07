library html;

import 'dart:collection';
import 'attr.dart';
import 'tag.dart';

class ElementListIterator extends Iterator<Element> {
  ElementList elementList;

  ElementListIterator(this.elementList);

  int _currentIndex = -1;

  @override
  Element get current => elementList[_currentIndex];

  @override
  bool moveNext() {
    return (++_currentIndex < elementList.length);
  }
}

abstract class ElementList extends Object with IterableMixin<Element> {
  int get length;
  /**
   * Returns the object at the given [index] in the list
   * or throws a [RangeError] if [index] is out of bounds.
   */
  Element operator [](int index);

  /**
   * Sets the value at the given [index] in the list to [value]
   * or throws a [RangeError] if [index] is out of bounds.
   */
  void operator []=(int index, Element value);

  void add(Element element);
  Element removeAt(int index);
  bool remove(Element element);
  void insert(int index, Element element);
  int indexOf(Element element);

  Iterator<Element> get iterator => new ElementListIterator(this);
}

abstract class CssClassSet {
  bool add(String value);
  bool remove(Object value);
  bool contains(Object value);
}

abstract class DataSet {
  String operator [](String name);
  void operator []=(String name, String value);
  Iterable<String> get keys;

  String toString() {
    return new Map.fromIterable(keys).toString();
  }

  bool remove(String key);
  static String attributePrefix = "data-";
}

class QueryCriteria {
  String byTag;
  String byId;
  String byClass;
  String byAttributes;
  bool recursive;
  QueryCriteria(
      {this.byTag,
      this.byId,
      this.byClass,
      this.byAttributes,
      this.recursive: true});
}

abstract class Node {
  static const int ATTRIBUTE_NODE = 2;
  static const int CDATA_SECTION_NODE = 4;
  static const int COMMENT_NODE = 8;
  static const int DOCUMENT_FRAGMENT_NODE = 11;
  static const int DOCUMENT_NODE = 9;
  static const int DOCUMENT_TYPE_NODE = 10;
  static const int ELEMENT_NODE = 1;
  static const int ENTITY_NODE = 6;

  static const int ENTITY_REFERENCE_NODE = 5;

  static const int NOTATION_NODE = 12;

  static const int PROCESSING_INSTRUCTION_NODE = 7;
  static const int TEXT_NODE = 3;

  int get nodeType;
  //String get nodeValue;
}

abstract class Element extends Node {
  ElementList get children;
  Element getElementById(String id);
  String get id;
  void set id(String id_);
  String get tagName;
  String get outerHtml;
  String get innerHtml;
  void set innerHtml(String html);
  Element querySelector(String selector);
  ElementList querySelectorAll(String selector);
  Element queryCriteria(QueryCriteria criteria);
  ElementList queryCriteriaAll(QueryCriteria criteria);
  Element query(
      {String byTag, String byId, String byClass, String byAttributes});
  ElementList queryAll(
      {String byTag, String byId, String byClass, String byAttributes});
  List<Node> get childNodes;
  void insertBefore(Node node, Node refNode);
  Node append(Node node);
  void remove();
  Element get parent;
  int get childIndex => parent.children.indexOf(this);
  CssClassSet get classes;
  Map<dynamic, String> get attributes;
  DataSet get dataset;
  //Element get nextElementSibling;
  //  Element();
  //  Element.tag(String tag);
  //  Element.html(String html);
}

abstract class BodyElement extends Element {}

abstract class HeadElement extends Element {
  //String title;
}

abstract class HtmlElement extends Element {}

abstract class Document {
  HtmlProvider provider;
  BodyElement get body;
  HeadElement get head;
  HtmlElement get html;

  Document(this.provider);

  void fixMissing({String title: '', String charset: CHARSET_UTF_8}) {
    int index = 0;

    if (charset != null) {
      fixNotExistingCharset(index, charset);
      index++;
    }

    //_fixNotExistingTitle(index, title);
  }

  void fixNotExistingCharset(int index, String charset) {
    if (charset != null) {
      for (Element element in head.children) {
        if (element.tagName == META) {
          if (element.attributes[CHARSET] != null) {
            return;
          }
        }
      }
      head.children.insert(index,
          provider.createElementTag(META)..attributes[CHARSET] = charset);
    }
  }
}

const String PROVIDER_BROWSER_NAME = 'browser';
const String PROVIDER_HTML5LIB_NAME = 'html5lib';

abstract class HtmlProvider {
  String get name;
  Document createDocument(
      {String html: '',
      String title: '',
      String charset: CHARSET_UTF_8,
      bool noCharsetTitleFix: false});

  Element createElementTag(String tag);
  Element createElementHtml(String html, {bool noValidate});

  Element wrapElement(dynamic elementImpl);
  dynamic unwrapElement(Element element);
}
