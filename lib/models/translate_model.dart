class TranslateModel {
  String? text;
  String? from;
  String? to;

  TranslateModel({this.text, this.from, this.to});

  TranslateModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}