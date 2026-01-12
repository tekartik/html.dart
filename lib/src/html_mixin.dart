import 'package:tekartik_html/attr.dart';
import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/tag.dart';

import 'html_base.dart';

/// Mixin providing common document fixing utilities.
mixin DocumentMixin implements DocumentBase {
  @override
  /// Fixes missing elements in the document head, such as charset and title.
  ///
  /// - [title]: The title to set if missing (default empty).
  /// - [charset]: The charset to set if missing (default UTF-8).
  void fixMissing({String title = '', String? charset = attrCharsetUtf8}) {
    var index = 0;

    if (charset != null) {
      fixNotExistingCharset(index, charset);
      index++;
    }

    //_fixNotExistingTitle(index, title);
  }

  /// Fixes the charset meta tag if it doesn't exist.
  ///
  /// - [index]: The position to insert the meta tag.
  /// - [charset]: The charset value to use.
  void fixNotExistingCharset(int index, String? charset) {
    if (charset != null) {
      for (final element in head.children) {
        if (element.tagName == tagMeta) {
          var charset = element.attributes[attrCharset];
          if (charset != null) {
            return;
          }
        }
      }
      head.children.insert(
        index,
        htmlProvider.createElementTag(tagMeta)
          ..attributes[attrCharset] = charset,
      );
    }
  }
}

/// Extension on [Element] for additional utilities.
extension ElementExtension on Element {
  /// Gets the index of this element within its parent's children.
  int get childIndex => parent!.children.indexOf(this);
}
