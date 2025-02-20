// ignore_for_file: provide_deprecation_message

library;

import 'dart:collection';
import 'attr.dart';

class ElementListIterator implements Iterator<Element> {
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
  void add(String value);
  void remove(String value);
  bool contains(String value);
}

abstract class DataSet {
  String? operator [](String name);
  void operator []=(String name, String value);
  Iterable<String> get keys;

  @override
  String toString() {
    return Map<String, Object?>.fromIterable(keys).toString();
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

/// Base node
abstract class Node {
  HtmlProvider get htmlProvider;
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

  /// Compat use textNode
  @Deprecated('Use textNode')
  static const int testNode = 3;

  /// Compat
  static const int textNode = 3;
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

  /// Node type
  int get nodeType;

  /// Node value, null for Element node, text for text node
  String? get nodeValue;

  /// Text content
  String? get textContent;

  /// Append child
  Node appendChild(Node child);

  /// Inserts a Node before the reference node as a child of a specified parent node.
  /// Insert before
  Node insertBefore(Node newNode, Node referenceNode);

  /// Removes a child node from the current element, which must be a child of the current node.
  Node removeChild(Node child);

  /// Replaces one child Node of the current one with the second one given in parameter.
  Node replaceChild(Node newChild, Node oldChild);
}

/// Text node
abstract class Text implements Node {
  /// Non-null text content
  String get text;
}

abstract class Element implements Node {
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

  /// Unmodifiable list of child nodes
  List<Node> get childNodes;

  /// Append a child node
  Node append(Node node);

  /// Remove the element from its parent
  void remove();

  Element? get parent;
  CssClassSet get classes;
  Map<Object, String> get attributes;
  DataSet get dataset;

  /// The setAttribute() method of the Element interface sets the value of an attribute on the specified element. If the attribute already exists, the value is updated; otherwise a new attribute is added with the specified name and value.
  ///
  /// To get the current value of an attribute, use getAttribute(); to remove an attribute, call removeAttribute().
  void setAttribute(String name, String value);

  //
  String? getAttribute(String name);
  bool hasAttribute(String name);

  void removeAttribute(String name);
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
  HtmlProvider get htmlProvider;
  BodyElement get body;
  HeadElement get head;
  HtmlElement get html;

  /// get the document title
  String get title;

  /// set the document title
  set title(String title);

  void fixMissing({String title = '', String? charset = attrCharsetUtf8});
}

const String providerBrowserName = 'browser'; // Legacy dart:html
const String providerWebName = 'web'; // web and js_interop
const String providerHtml5LibName = 'html5lib'; // html multiplatform lib

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
  Text createTextNode(String text);

  // wrap a native document
  Document wrapDocument(Object? documentImpl);

  // get the native document
  Object? unwrapDocument(Document? document);

  // wrap a native element
  Element wrapElement(Object elementImpl);

  // get the native element
  Object unwrapElement(Element element);

  // wrap a native element
  Node wrapNode(Object nodeImpl);

  // get the native element
  Object unwrapNode(Node node);
}
