import 'package:tekartik_html/html.dart';

/// Builds a CSS selector string from optional tag, id, class, and attributes.
///
/// - [byTag]: The tag name (e.g., 'div').
/// - [byId]: The id (e.g., 'myId').
/// - [byClass]: The class (e.g., 'myClass').
/// - [byAttributes]: Additional attributes (e.g., 'type="text"').
String buildSelector({
  String? byTag,
  String? byId,
  String? byClass,
  String? byAttributes,
}) {
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

final _startTagRegExp = RegExp(r'<(\w+)');

/// Parents of the table parts, which the html parser drops in a div (same
/// map as html5lib `Element.html`, plus `th`).
const _tablePartParentTags = <String, String>{
  'caption': 'table',
  'colgroup': 'table',
  'col': 'colgroup',
  'thead': 'table',
  'tbody': 'table',
  'tfoot': 'table',
  'tr': 'tbody',
  'td': 'tr',
  'th': 'tr',
};

/// The tag of the element to parse [html] in when its first element is a
/// table part (`tr`, `td`...), null otherwise.
String? htmlFragmentParentTag(String html) {
  final match = _startTagRegExp.firstMatch(html);
  if (match == null) {
    return null;
  }
  return _tablePartParentTags[match.group(1)!.toLowerCase()];
}

/// Builds a CSS selector string from a [QueryCriteria] object.
///
/// Includes scope handling if not recursive.
String buildCriteriaSelector(QueryCriteria criteria) {
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
