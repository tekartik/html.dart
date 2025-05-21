import 'package:tekartik_html/attr.dart';
import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/tag.dart';

import 'html_base.dart';

mixin DocumentMixin implements DocumentBase {
  @override
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

extension ElementExtension on Element {
  /// Get a child index
  int get childIndex => parent!.children.indexOf(this);
}
