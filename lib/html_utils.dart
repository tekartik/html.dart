import 'html.dart';

// Recursive into the parent to find the first parent matching the give id
/// [includeElement] if true also check the current element id
Element? findFirstAncestorWithId(
  Element element,
  String id, [
  bool? includeElement,
]) {
  Element? parent;
  if (includeElement == true) {
    parent = element;
  } else {
    parent = element.parent;
  }
  while (parent != null && parent.id != id) {
    parent = parent.parent;
  }
  return parent;
}

// Recursive into the parent to find the first parent matching the class
/// [includeElement] if true also check the current element class
Element? findFirstAncestorWithClass(
  Element element,
  String klass, [
  bool? includeElement,
]) {
  Element? parent;
  if (includeElement == true) {
    parent = element;
  } else {
    parent = element.parent;
  }
  while (parent != null && !parent.classes.contains(klass)) {
    parent = parent.parent;
  }
  return parent;
}
