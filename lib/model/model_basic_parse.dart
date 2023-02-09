class ModelBasicParse {
  int statusCode;
  String statusText;
  String message;
  List<dynamic> data;

  ModelBasicParse({required this.statusCode, required this.statusText, required this.message,required this.data});

  ModelBasicParse.fromJson(Map<String, dynamic> json): //{
    statusCode = json['status_code'],
    statusText = json['status_text'],
    message = json['message'],
    data =   <dynamic>[];
    // if (json['data'] != null) {
    //   data =   <dynamic>[];
    //   json['data'].forEach((v) {
    //     data.add(dynamic.fromJson(v));
    //   });
    // }
 // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_text'] = this.statusText;
    data['message'] = this.message;
   // data['data'] = this.data;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}
