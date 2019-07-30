class SignInRequestParams {
  String phone;
  String deviceUID;

  SignInRequestParams({this.phone, this.deviceUID});

  SignInRequestParams.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    deviceUID = json['deviceUID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['deviceUID'] = this.deviceUID;
    return data;
  }
}