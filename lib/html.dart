// ignore_for_file: provide_deprecation_message

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
  @override
  int get length;

  /// Returns the object at the given [index] in the list
  /// or throws a [RangeError] if [index] is out of bounds.
  Element operator [](int index);

  /// Sets the value at the given [index] in the list to [value]
  /// or throws a [RangeError] if [index] is out of bounds.
  void operator []=(int index, Element value);

  void add(Element element);
  Element? removeAt(int index);
  bool remove(Element element);
  void insert(int index, Element element);
  int indexOf(Element element);

  @override
  Iterator<Element> get iterator => ElementListIterator(this);

  /// remove all element
  void clear();
}

abstract class CssClassSet {
  bool add(String value);
  bool remove(Object value);
  bool contains(Object value);
}

abstract class DataSet {
  String? operator [](String name);
  void operator []=(String name, String value);
  Iterable<String> get keys;

  @override
  String toString() {
    return Map.fromIterable(keys).toString();
  }

  bool remove(String key);
  static String attributePrefix = 'data-';
}

class QueryCriteria {
  String? byTag;
  String? byId;
  String? byClass;
  String? byAttributes;
  bool recursive;
  QueryCriteria(
      {this.byTag,
      this.byId,
      this.byClass,
      this.byAttributes,
      this.recursive = true});
}

abstract class Node {
  static const int attributeNode = 2;
  static const int cdataSectionNode = 4;
  static const int commentNode = 8;
  static const int documentFragmentNode = 11;
  static const int documentNode = 9;
  static const int documentTypeNode = 10;
  static const int elementNode = 1;
  static const int entityNode = 6;

  static const int entityReferenceNode = 5;

  static const int notationNode = 12;

  static const int processInstructionNode = 7;
  static const int testNode = 3;
  @deprecated
  // ignore: constant_identifier_names
  static const int ATTRIBUTE_NODE = 2;
  @deprecated
  // ignore: constant_identifier_names
  static const int CDATA_SECTION_NODE = 4;
  @deprecated
  // ignore: constant_identifier_names
  static const int COMMENT_NODE = 8;
  @deprecated
  // ignore: constant_identifier_names
  static const int DOCUMENT_FRAGMENT_NODE = 11;
  @deprecated
  // ignore: constant_identifier_names
  static const int DOCUMENT_NODE = 9;
  @deprecated
  // ignore: constant_identifier_names
  static const int DOCUMENT_TYPE_NODE = 10;
  @deprecated
  // ignore: constant_identifier_names
  static const int ELEMENT_NODE = 1;
  @deprecated
  // ignore: constant_identifier_names
  static const int ENTITY_NODE = 6;
  @deprecated
  // ignore: constant_identifier_names
  static const int ENTITY_REFERENCE_NODE = 5;
  @deprecated
  // ignore: constant_identifier_names
  static const int NOTATION_NODE = 12;
  @deprecated
  // ignore: constant_identifier_names
  static const int PROCESSING_INSTRUCTION_NODE = 7;
  @deprecated
  // ignore: constant_identifier_names
  static const int TEXT_NODE = 3;

  int get nodeType;
  String? get nodeValue;
}

abstract class Element extends Node {
  ElementList get children;
  Element? getElementById(String id);
  String get id;
  set id(String id);
  String get tagName;
  String get outerHtml;
  String get innerHtml;
  String get text;
  set text(String text);
  set innerHtml(String html);
  Element? querySelector(String selector);
  ElementList querySelectorAll(String selector);
  Element? queryCriteria(QueryCriteria criteria);
  ElementList queryCriteriaAll(QueryCriteria criteria);
  Element? query(
      {String? byTag, String? byId, String? byClass, String? byAttributes});
  ElementList queryAll(
      {String? byTag, String? byId, String? byClass, String? byAttributes});
  List<Node> get childNodes;
  void insertBefore(Node node, Node refNode);
  Node append(Node node);
  void remove();
  Element? get parent;
  int get childIndex => parent!.children.indexOf(this);
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

  /// get the document title
  String get title;

  /// set the document title
  set title(String title);

  void fixMissing({String title = '', String? charset = attrCharsetUtf8}) {
    var index = 0;

    if (charset != null) {
      fixNotExistingCharset(index, charset);
      index++;
    }

    //_fixNotExistingTitle(index, title);
  }

  void fixNotExistingCharset(int index, String? charset) {
    if (charset != null) {
      for (final element in head.children) {
        if (element.tagName == tagMeta) {
          if (element.attributes[attrCharset] != null) {
            return;
          }
        }
      }
      head.children.insert(
          index,
          provider.createElementTag(tagMeta)
            ..attributes[attrCharset] = charset);
    }
  }
}

const String providerBrowserName = 'browser';
const String providerHtml5LibName = 'html5lib';

abstract class HtmlProvider {
  String get name;

  /// charset can be set to null
  Document createDocument(
      {String html = '',
      String title = '',
      String? charset = attrCharsetUtf8,
      bool noCharsetTitleFix = false});

  Element createElementTag(String tag);
  Element createElementHtml(String html, {bool? noValidate});

  // wrap a native document
  Document wrapDocument(dynamic documentImpl);

  // get the native document
  dynamic unwrapDocument(Document? document);

  // wrap a native element
  Element? wrapElement(dynamic elementImpl);

  // get the native element
  dynamic unwrapElement(Element? element);
}
