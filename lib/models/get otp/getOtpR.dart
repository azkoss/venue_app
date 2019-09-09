class GetOTPResponseModel {
  int code;
  String status;
  int numberStatus;
  String message;
  int otp;
  String phone;


  GetOTPResponseModel(
      {this.code,
        this.status,
        this.numberStatus,
        this.message,
        this.otp,
        this.phone
      });

  GetOTPResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    numberStatus = json['numberStatus'];
    message = json['message'];
    otp = json['otp'];
    phone = json['phone'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['numberStatus'] = this.numberStatus;
    data['message'] = this.message;
    data['otp'] = this.otp;
    data['phone'] = this.phone;

    return data;
  }
}

