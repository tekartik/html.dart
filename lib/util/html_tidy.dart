library tekartik_html.util.html_tidy;

import '../html.dart';
import 'dart:convert';

List<String> _voidTags = [
  'area',
  'base',
  'br',
  'col',
  'embed',
  'hr',
  'img',
  'input',
  'keygen',
  'link',
  'menuitem',
  'meta',
  'param',
  'source',
  'track',
  'wbr'
];

List<String> _rawTags = ['script', 'style'];

List<String> _inlineTags = [
  'meta', 'title', 'link', // for head
  "h1", "h2", "h3", "h4", "h5", "h6", "span", "a"
];

///
/// Returns `true` if [rune] represents a whitespace character.
///
/// The definition of whitespace matches that used in [String.trim] which is
/// based on Unicode 6.2. This maybe be a different set of characters than the
/// environment's [RegExp] definition for whitespace, which is given by the
/// ECMAScript standard: http://ecma-international.org/ecma-262/5.1/#sec-15.10
///
/// from quiver
///
bool _isWhitespace(int rune) => ((rune >= 0x0009 && rune <= 0x000D) ||
    rune == 0x0020 ||
    rune == 0x0085 ||
    rune == 0x00A0 ||
    rune == 0x1680 ||
    rune == 0x180E ||
    (rune >= 0x2000 && rune <= 0x200A) ||
    rune == 0x2028 ||
    rune == 0x2029 ||
    rune == 0x202F ||
    rune == 0x205F ||
    rune == 0x3000 ||
    rune == 0xFEFF);

class HtmlTidyOption {
  String indent = '\t';

  /// Make content fit in 80 chars
  int contentLength = 80;
}

// Character constants.
const int _LF = 10;
const int _CR = 13;

// <h1>test</h1>
// <style>body {opacity: 0}</style>
bool _hasSingleTextNodeLine(Element element) {
  List<Node> childNodes = element.childNodes;
  if (childNodes.length == 1) {
    Node node = childNodes.first;
    if (node.nodeType == Node.TEXT_NODE) {
      String value = node.nodeValue;
      if (!(value.codeUnits.contains(_CR) || value.codeUnits.contains(_LF))) {
        return true;
      }
    }
  }
  return false;
}

bool _inlineContentForTag(String tagName) {
  if (_inlineTags.contains(tagName)) {
    return true;
  } else {
    return false;
  }
}

bool _doNotConvertContentForTag(String tagName) {
  switch (tagName) {
    case 'pre':
      return true;
    default:
      return false;
  }
}

List<String> _wordSplit(String input) {
  List<String> out = [];
  StringBuffer sb = new StringBuffer();

  _addCurrent() {
    if (sb.length > 0) {
      out.add(sb.toString());
      sb = new StringBuffer();
    }
  }
  for (int rune in input.runes) {
    if (_isWhitespace(rune)) {
      _addCurrent();
    } else {
      sb.writeCharCode(rune);
    }
  }
  _addCurrent();
  return out;
}

List<String> convertContent(String input, HtmlTidyOption option) {
  List<String> words = _wordSplit(input);
  List<String> out = [];

  StringBuffer sb = new StringBuffer();

  _addCurrent() {
    if (sb.length > 0) {
      out.add(sb.toString());
      sb = new StringBuffer();
    }
  }
  for (int i = 0; i < words.length; i++) {
    String word = words[i];
    if (sb.length == 0) {
      // if empty never create a new line
    } else if (sb.length + word.length + 1 > option.contentLength) {
      _addCurrent();
    } else {
      // add a space
      sb.write(' ');
    }
    sb.write(word);
  }
  _addCurrent();
  return out;
}

_addSubs(List<String> out, Iterable<String> subs, HtmlTidyOption option) {
  for (String sub in subs) {
    // remove empty lines
    if (sub.trim().length > 0) {
      out.add('${option.indent}${sub}');
    }
  }
}

// reference: http://www.dirtymarkup.com/
Iterable<String> htmlTidyElement(Element element, [HtmlTidyOption option]) =>
    _htmlTidyElement(element, option, false);

Iterable<String> _htmlTidyElement(Element element,
    [HtmlTidyOption option, bool inline]) {
  if (element == null) {
    return null;
  }

  String tagName = element.tagName;
  // default option
  if (option == null) {
    option = new HtmlTidyOption();
  }
  List<String> out = [];
  element.childNodes;

  // do not convert content for inlined and special tags
  bool inlineContent = inline ||
      _inlineContentForTag(tagName) ||
      _hasSingleTextNodeLine(element);
  // Only so this if there is no child or
  List<Node> childNodes = [];
  List<Node> allChildNodes = element.childNodes;
  List<Element> childElements = [];
  for (Node node in allChildNodes) {
    if (node is Element) {
      childElements.add(node);
      childNodes.add(node);
    } else if (node.nodeType == Node.TEXT_NODE) {
      childNodes.add(node);
    }
  }

  // only do this for single child elements
  if (childNodes.isEmpty) {
    inlineContent = true;
  } else if (inlineContent) {
    if (childElements.length > 0) {
      inlineContent = false;
    }
  }

  //|| element.childNodes.isEmpty;
  bool _doNotConvertContent =
      inlineContent || _doNotConvertContentForTag(tagName);

  StringBuffer sb = new StringBuffer();

  _addNode(Node node) {
    if (node is Element) {
      _addSubs(out, _htmlTidyElement(node, option, false), option);
    } else if (node.nodeType == Node.TEXT_NODE) {
      if (inlineContent) {
        sb.write(node.nodeValue);
      } else {
        if (_doNotConvertContent) {
          out.add(node.nodeValue);
        } else {
          // for style/script split & join to prevent \r \n
          if (_rawTags.contains(tagName)) {
            _addSubs(out, LineSplitter.split(node.nodeValue), option);
          } else {
            List<String> subs = convertContent(node.nodeValue, option);
            if (subs.isNotEmpty) {
              _addSubs(out, subs, option);
            }
          }
        }
      }
    }
  }

  if (inlineContent) {
    sb.write(_beginTag(element));
  } else {
    out.add(_beginTag(element));
  }
  for (Node node in element.childNodes) {
    _addNode(node);
  }
  String endTag = _endTag(element);
  if (endTag != null) {
    if (inlineContent) {
      sb.write(endTag);
    } else {
      out.add(endTag);
    }
  }

  if (inlineContent) {
    out.add(sb.toString());
  }
  return out;
}

String _beginTag(Element element) {
  StringBuffer sb = new StringBuffer();
  sb.write('<${element.tagName}');
  element.attributes.forEach((key, value) {
    sb.write(' $key');
    if (value.length > 0) {
      sb.write('="$value"');
    }
  });
  sb.write('>');
  return sb.toString();
}

String _endTag(Element element) {
  if (_voidTags.contains(element.tagName)) {
    return null;
  } else {
    return '</${element.tagName}>';
  }
}

Iterable<String> htmlTidyDocument(Document document, [HtmlTidyOption option]) {
  if (document == null) {
    return null;
  }
  List<String> out = [];
  out.add('<!DOCTYPE html>');
  out.add(_beginTag(document.html));
  out.addAll(htmlTidyElement(document.head, option));
  out.addAll(htmlTidyElement(document.body, option));
  out.add(_endTag(document.html));
  return out;
}
