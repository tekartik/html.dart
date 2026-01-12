// ignore_for_file: provide_deprecation_message

library;

import 'dart:collection';
import 'attr.dart';

/// Iterator over an [ElementList].
class ElementListIterator implements Iterator<Element> {
  /// The list being iterated over.
  ElementList elementList;

  /// Creates an iterator for the given [elementList].
  ElementListIterator(this.elementList);

  int _currentIndex = -1;

  @override
  Element get current => elementList[_currentIndex];

  @override
  bool moveNext() {
    return (++_currentIndex < elementList.length);
  }
}

/// A list-like interface for collections of [Element] objects.
abstract class ElementList extends Object with IterableMixin<Element> {
  @override
  int get length;

  /// Returns the object at the given [index] in the list
  /// or throws a [RangeError] if [index] is out of bounds.
  Element operator [](int index);

  /// Sets the value at the given [index] in the list to [value]
  /// or throws a [RangeError] if [index] is out of bounds.
  void operator []=(int index, Element value);

  /// Add an element to the list.
  void add(Element element);

  /// Remove an element at a specific index.
  Element? removeAt(int index);

  /// Remove an element from the list.
  bool remove(Element element);

  /// Insert an element at a specific index.
  void insert(int index, Element element);

  /// Get the index of an element.
  int indexOf(Element element);

  @override
  Iterator<Element> get iterator => ElementListIterator(this);

  /// Remove all elements from the list.
  void clear();
}

/// Represents a set of CSS classes for an element.
abstract class CssClassSet {
  /// Add a class name to the set.
  void add(String value);

  /// Remove a class name from the set.
  void remove(String value);

  /// Returns true if the class name is present.
  bool contains(String value);
}

/// Represents HTML data-* attributes for an element.
abstract class DataSet {
  /// Access a data attribute by name (without the 'data-' prefix).
  String? operator [](String name);

  /// Set a data attribute by name (without the 'data-' prefix).
  void operator []=(String name, String value);

  /// Iterates the data attribute keys (without the 'data-' prefix).
  Iterable<String> get keys;

  @override
  String toString() {
    return Map<String, Object?>.fromIterable(keys).toString();
  }

  /// Remove a data attribute by key. Returns true if removed.
  bool remove(String key);

  /// Default prefix used for data attributes.
  static String attributePrefix = 'data-';
}

/// Criteria used for querying elements (tag, id, class, or attributes).
class QueryCriteria {
  /// The tag name to query.
  String? byTag;

  /// The id to query.
  String? byId;

  /// The class name to query.
  String? byClass;

  /// Additional attributes to query.
  String? byAttributes;

  /// Whether the query should be recursive.
  bool recursive;

  /// Creates a [QueryCriteria] object with optional parameters.
  QueryCriteria({
    this.byTag,
    this.byId,
    this.byClass,
    this.byAttributes,
    this.recursive = true,
  });
}

/// Base abstraction for a DOM-like node.
abstract class Node {
  /// The HTML provider associated with this node.
  HtmlProvider get htmlProvider;

  /// Node type for attribute nodes.
  static const int attributeNode = 2;

  /// Node type for CDATA section nodes.
  static const int cdataSectionNode = 4;

  /// Node type for comment nodes.
  static const int commentNode = 8;

  /// Node type for document fragment nodes.
  static const int documentFragmentNode = 11;

  /// Node type for document nodes.
  static const int documentNode = 9;

  /// Node type for document type nodes.
  static const int documentTypeNode = 10;

  /// Node type for element nodes.
  static const int elementNode = 1;

  /// Node type for entity nodes.
  static const int entityNode = 6;

  /// Node type for entity reference nodes.
  static const int entityReferenceNode = 5;

  /// Node type for notation nodes.
  static const int notationNode = 12;

  /// Node type for processing instruction nodes.
  static const int processInstructionNode = 7;

  /// Node type for text nodes.
  static const int textNode = 3;

  /// Deprecated: Use [textNode] instead.
  @Deprecated('Use textNode')
  static const int testNode = 3;

  /// Node type.
  int get nodeType;

  /// Node value, null for element nodes, text for text nodes.
  String? get nodeValue;

  /// Text content of the node.
  String? get textContent;

  /// Appends a child node.
  Node appendChild(Node child);

  /// Inserts a node before the reference node as a child of the current node.
  Node insertBefore(Node newNode, Node referenceNode);

  /// Removes a child node from the current node.
  Node removeChild(Node child);

  /// Replaces one child node with another.
  Node replaceChild(Node newChild, Node oldChild);

  /// The parent node, or null if not attached.
  Node? get parentNode;
}

/// Text node (non-nullable content).
abstract class Text implements Node {
  /// Non-null text content.
  String get text;
}

/// Represents an HTML element.
abstract class Element implements Node {
  /// The list of child elements.
  ElementList get children;

  /// Finds an element by its id.
  Element? getElementById(String id);

  /// The id of the element.
  String get id;
  set id(String id);

  /// The tag name of the element.
  String get tagName;

  /// The outer HTML of the element.
  String get outerHtml;

  /// The inner HTML of the element.
  String get innerHtml;
  set innerHtml(String html);

  /// The text content of the element.
  String get text;
  set text(String text);

  /// Finds the first element matching the given CSS selector.
  Element? querySelector(String selector);

  /// Finds all elements matching the given CSS selector.
  ElementList querySelectorAll(String selector);

  /// Finds the first element matching the given [QueryCriteria].
  Element? queryCriteria(QueryCriteria criteria);

  /// Finds all elements matching the given [QueryCriteria].
  ElementList queryCriteriaAll(QueryCriteria criteria);

  /// Finds the first element matching the given query parameters.
  Element? query({
    String? byTag,
    String? byId,
    String? byClass,
    String? byAttributes,
  });

  /// Finds all elements matching the given query parameters.
  ElementList queryAll({
    String? byTag,
    String? byId,
    String? byClass,
    String? byAttributes,
  });

  /// The list of child nodes.
  List<Node> get childNodes;

  /// Appends a child node.
  Node append(Node node);

  /// Removes the element from its parent.
  void remove();

  /// The parent element, or null if not attached.
  Element? get parent;

  /// The set of CSS classes for the element.
  CssClassSet get classes;

  /// The attributes of the element.
  Map<Object, String> get attributes;

  /// The data-* attributes of the element.
  DataSet get dataset;

  /// Sets an attribute on the element.
  void setAttribute(String name, String value);

  /// Gets the value of an attribute.
  String? getAttribute(String name);

  /// Checks if the element has the specified attribute.
  bool hasAttribute(String name);

  /// Removes the specified attribute from the element.
  void removeAttribute(String name);
}

/// Represents the body element of a document.
abstract class BodyElement extends Element {}

/// Represents the head element of a document.
abstract class HeadElement extends Element {}

/// Represents the root HTML element of a document.
abstract class HtmlElement extends Element {}

/// Represents an HTML document.
abstract class Document {
  /// The HTML provider associated with this document.
  HtmlProvider get htmlProvider;

  /// The body element of the document.
  BodyElement get body;

  /// The head element of the document.
  HeadElement get head;

  /// The root HTML element of the document.
  HtmlElement get html;

  /// The title of the document.
  String get title;
  set title(String title);

  /// Ensures common missing document pieces are present (e.g., head/meta/title).
  ///
  /// [title] will be used as the document title if none exists.
  /// [charset] can be null to indicate no charset meta tag should be added.
  void fixMissing({String title = '', String? charset = attrCharsetUtf8});
}

/// Name used for the browser provider.
const String providerBrowserName = 'browser'; // Legacy dart:html

/// Name used for the web/js-interop provider.
const String providerWebName = 'web'; // web and js_interop

/// Name used for the html5lib provider.
const String providerHtml5LibName = 'html5lib'; // html multiplatform lib

/// Provider abstraction for creating and wrapping DOM objects.
///
/// Implementations should create/wrapping native DOM types for the platform and
/// expose factory/wrapper methods used by the package.
abstract class HtmlProvider {
  /// The provider name identifying the implementation.
  String get name;

  /// Create a new document from [html] string. Optionally set [title] and
  /// [charset]. If [charset] is null no charset meta will be set.
  Document createDocument({
    String html = '',
    String title = '',
    String? charset = attrCharsetUtf8,
    bool noCharsetTitleFix = false,
  });

  /// Create a new element by tag name.
  Element createElementTag(String tag);

  /// Create element(s) by parsing [html] and returning the first element.
  Element createElementHtml(String html, {bool? noValidate});

  /// Create nodes by parsing [html] and returning the resulting Node list.
  List<Node> createNodesHtml(String html, {bool? noValidate});

  /// Create elements by parsing [html] and returning the resulting Element list.
  List<Element> createElementsHtml(String html, {bool? noValidate});

  /// Create a text node with given [text] content.
  Text createTextNode(String text);

  /// Wrap a native platform document instance into the package [Document].
  Document wrapDocument(Object documentImpl);

  /// Unwrap a package [Document] into the underlying native document.
  Object unwrapDocument(Document document);

  /// Wrap a native platform element into the package [Element].
  Element wrapElement(Object elementImpl);

  /// Unwrap a package [Element] into the underlying native element.
  Object unwrapElement(Element element);

  /// Wrap a native platform node into the package [Node].
  Node wrapNode(Object nodeImpl);

  /// Unwrap a package [Node] into the underlying native node.
  Object unwrapNode(Node node);
}

/// Extension helpers on [Node] provided by the package.
extension TekartikHtmlNodeExt on Node {
  /// Append a text node.
  Text appendText(String text) {
    var textNode = htmlProvider.createTextNode(text);
    appendChild(textNode);
    return textNode;
  }

  /// Apppend a line feed.
  void appendLf() {
    appendText('\n');
  }

  /// Create a new element and append it.
  Element appendElementTag(String tag) {
    var element = htmlProvider.createElementTag(tag);
    appendChild(element);
    return element;
  }

  /// Append an element from an html string.
  Element appendElementHtml(String html, {bool? noValidate}) {
    var element = htmlProvider.createElementHtml(html, noValidate: noValidate);
    appendChild(element);
    return element;
  }

  /// Append a list of elements from an html string.
  List<Element> appendElementsHtml(String html, {bool? noValidate}) {
    var elements = htmlProvider.createElementsHtml(
      html,
      noValidate: noValidate,
    );
    appendChildren(elements);
    return elements;
  }

  /// Append a list of children.
  List<Node> appendChildren(List<Node> children) {
    for (var element in List.of(children)) {
      appendChild(element);
    }
    return children;
  }

  /// Append nodes as is.
  List<Node> appendNodesHtml(String html, {bool? noValidate}) {
    var nodes = htmlProvider.createNodesHtml(html, noValidate: noValidate);
    return appendChildren(nodes);
  }

  /// The Element.replaceWith() method replaces this Element in the children list
  /// of its parent with a set of Node objects or strings.
  void replaceWith(Node otherNode) {
    parentNode!.replaceChild(otherNode, this);
  }
}

/// Helper extension methods on [HtmlProvider] used internally.
extension TekartikHtmlNodeMixin on HtmlProvider {
  /// Unwrap a node or return null.
  Object? unwrapNodeOrNull(Node? node) {
    if (node == null) {
      return null;
    }
    return unwrapNode(node);
  }

  /// Wrap a node or return null.
  Node? wrapNodeOrNull(Object? nodeImpl) {
    if (nodeImpl == null) {
      return null;
    }
    return wrapNode(nodeImpl);
  }
}
