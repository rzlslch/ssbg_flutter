import 'package:ssbg_flutter/models/config_model.dart';

String propPrefix = "---\n";
String propSuffix = "\n---\n";

(ConfigModel?, String) configScanner(String content) {
  int propPrefixIndex = content.indexOf(propPrefix);
  int propSuffixIndex = content.lastIndexOf(propSuffix);
  String propString = "";

  String contentFree = content;

  if (propPrefixIndex > -1 && propSuffixIndex > -1) {
    propString =
        content.substring(propPrefixIndex + propPrefix.length, propSuffixIndex);
    contentFree = content.replaceRange(
        propPrefixIndex, propSuffixIndex + propSuffix.length, "");
  } else {
    return (null, contentFree);
  }

  Map<String, String> props = {};

  for (var c in propString.split("\n")) {
    List<String> propC = c.split(":");
    String propKey = propC[0].toString().trim();
    propC.removeAt(0);
    String propValue = propC.join(":").trim();
    props[propKey] = propValue;
  }

  ConfigModel config = ConfigModel(props);

  return (config, contentFree);
}
