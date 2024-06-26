class ResumenModel {
  String? title;
  String? content;
  String? thumbnail;
  String? dayAdded;
  String? link;

  ResumenModel({this.title, this.content, this.thumbnail, this.dayAdded, this.link});

  ResumenModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    dayAdded = json['dayAdded'];
    thumbnail = json['thumbnail'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['thumbnail'] = this.thumbnail;
    data['dayAdded'] = this.dayAdded;
    data['link'] = this.link;
    return data;
  }
}