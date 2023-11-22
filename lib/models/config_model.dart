class ConfigModel {
  String layout = "";
  String? title;
  String? permalink;
  // DateTime? date;
  String? date;
  // num? date;
  List? categories;
  bool? comments;

  ConfigModel(Map<String, String> props) {
    layout = props["layout"]!;
    if (props.containsKey("title")) title = props["title"];
    if (props.containsKey("permalink")) permalink = props["permalink"];
    if (props.containsKey("date")) {
      // List dateList = props["date"]!.trim().split(" ");
      // List dateYMD = dateList[0].split("-");
      // List dateH = dateList[1].split(":");
      // DateTime timestamp = DateTime(
      //     int.parse(dateYMD[0]),
      //     int.parse(dateYMD[1]),
      //     int.parse(dateYMD[2]),
      //     int.parse(dateH[0]),
      //     int.parse(dateH[1]));
      // date = timestamp;
      date = props["date"];
    }
    if (props.containsKey("categories")) {
      categories = props["categories"]!.split(",");
    }
    if (props.containsKey("comments")) {
      comments = props["comments"] == "true" ? true : false;
    }
  }
}
