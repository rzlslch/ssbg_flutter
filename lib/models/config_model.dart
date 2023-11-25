class ConfigModel {
  String layout = "";
  String? title;
  String? permalink;
  String? date;
  List? categories;
  bool? comments;
  String url = "";
  ConfigModel? prev;
  ConfigModel? next;
  String? name;

  ConfigModel(Map<String, String> props) {
    layout = props["layout"]!;
    if (props.containsKey("title")) title = props["title"];
    if (props.containsKey("permalink")) {
      permalink = props["permalink"];
      url = "${props["permalink"]}.html";
    } else {
      url = "${props["title"]?.replaceAll(RegExp(r' '), "-")}.html";
    }
    if (props.containsKey("date")) date = props["date"];
    if (props.containsKey("categories")) {
      categories = props["categories"]!.split(",");
    }
    if (props.containsKey("comments")) {
      comments = props["comments"] == "true" ? true : false;
    }
    if (props.containsKey("name")) name = props["name"];
  }

  setPrev(ConfigModel prev) {
    this.prev = prev;
  }

  setNext(ConfigModel next) {
    this.next = next;
  }

  toMap() {
    return {
      'layout': layout,
      'title': title,
      'permalink': permalink,
      'date': date,
      'categories': categories,
      'comments': comments,
      'url': url,
      'prev': prev != null
          ? {
              'layout': prev?.layout,
              'title': prev?.title,
              'permalink': prev?.permalink,
              'date': prev?.date,
              'categories': prev?.categories,
              'comments': prev?.comments,
              'url': prev?.url,
            }
          : null,
      'next': next != null
          ? {
              'layout': next?.layout,
              'title': next?.title,
              'permalink': next?.permalink,
              'date': next?.date,
              'categories': next?.categories,
              'comments': next?.comments,
              'url': next?.url,
            }
          : null
    };
  }

  @override
  toString() {
    List<String> listTemplate = [];
    listTemplate.add("layout: $layout");
    if (title != null) listTemplate.add("title: $title");
    if (permalink != null) listTemplate.add("permalink: $permalink");
    if (date != null) listTemplate.add("date: $date");
    if (categories != null) {
      listTemplate.add("categories: ${categories?.join(",")}");
    }
    if (comments != null) listTemplate.add("comments: ${comments.toString()}");
    return """---
${listTemplate.join("\n")}
---
""";
  }
}
