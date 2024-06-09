class TranscriptionModel {
  String? url;
  String? message;
  String? lang;

  TranscriptionModel({this.url, this.message, this.lang});

  TranscriptionModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    message = json['message'];
    lang = json['lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['message'] = this.message;
    data['lang'] = this.lang;
    return data;
  }
}