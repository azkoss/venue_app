class SignInResponse {
  int code;
  String status;
  String description;
  Token token;

  SignInResponse({this.code, this.status, this.description, this.token});

  SignInResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    description = json['description'];
    token = json['token'] != null ? new Token.fromJson(json['token']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['description'] = this.description;
    if (this.token != null) {
      data['token'] = this.token.toJson();
    }
    return data;
  }
}

class Token {
  int createdAt;
  int updatedAt;
  String id;
  String deviceUID;
  String token;
  bool isExpired;
  int expiresAt;
  String user;

  Token(
      {this.createdAt,
        this.updatedAt,
        this.id,
        this.deviceUID,
        this.token,
        this.isExpired,
        this.expiresAt,
        this.user});

  Token.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    deviceUID = json['deviceUID'];
    token = json['token'];
    isExpired = json['isExpired'];
    expiresAt = json['expiresAt'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['deviceUID'] = this.deviceUID;
    data['token'] = this.token;
    data['isExpired'] = this.isExpired;
    data['expiresAt'] = this.expiresAt;
    data['user'] = this.user;
    return data;
  }
}