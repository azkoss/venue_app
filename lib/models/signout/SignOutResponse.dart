class SignOutResponse {
  int code;
  String status;
  String description;

  SignOutResponse({this.code, this.status, this.description});

  SignOutResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['description'] = this.description;
    return data;
  }
}