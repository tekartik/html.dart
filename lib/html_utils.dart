import 'html.dart';

// Recursive into the parent to find the first parent matching the give id
/// [includeElement] if true also check the current element id
Element findFirstAncestorWithId(Element element, String id,
    [bool includeElement]) {
  Element parent;
  if (includeElement == true) {
    parent = element;
  } else {
    parent = element.parent;
  }
  while (parent.id != id) {
    parent = parent.parent;
    if (parent == null) {
      return null;
    }
  }
  return parent;
}
