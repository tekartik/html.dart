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
