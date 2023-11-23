class ConfigModel {
  String layout = "";
  String? title;
  String? permalink;
  String? date;
  List? categories;
  bool? comments;

  ConfigModel(Map<String, String> props) {
    layout = props["layout"]!;
    if (props.containsKey("title")) title = props["title"];
    if (props.containsKey("permalink")) permalink = props["permalink"];
    if (props.containsKey("date")) date = props["date"];
    if (props.containsKey("categories")) {
      categories = props["categories"]!.split(",");
    }
    if (props.containsKey("comments")) {
      comments = props["comments"] == "true" ? true : false;
    }
  }
}
