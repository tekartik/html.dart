import 'package:tekartik_html/html.dart';

/// Selector from query
String buildSelector(
    {String? byTag, String? byId, String? byClass, String? byAttributes}) {
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
