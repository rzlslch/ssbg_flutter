import 'package:highlighter/highlighter.dart';
import 'package:highlighter/languages/arduino.dart';
import 'package:highlighter/languages/htmlbars.dart';
import 'package:highlighter/languages/javascript.dart';
import 'package:highlighter/languages/python.dart';
import 'package:highlighter/languages/xml.dart';

String mdHighlighter(String source, String language) {
  Map<String, Mode> languages = {
    "c": arduino,
    "html": htmlbars,
    "javascript": javascript,
    "python": python,
    "xml": xml,
  };

  highlight.registerLanguages(languages);
  Result result = highlight.parse(source, language: language);
  String html = result.toHtml();
  html = "<pre><code>$html</code></pre>";
  return html;
}
