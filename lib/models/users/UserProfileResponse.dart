class UserProfileResponse {
  int code;
  String status;
  String description;
  User user;

  UserProfileResponse({this.code, this.status, this.description, this.user});

  UserProfileResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    description = json['description'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['description'] = this.description;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int createdAt;
  int updatedAt;
  String id;
  String firstName;
  String lastName;
  String description;
  String phone;
  int otp;
  String email;
  String location;
  int latitude;
  int longitude;
  int role;
  bool active;
  int lastLoggedInAt;

  User(
      {this.createdAt,
        this.updatedAt,
        this.id,
        this.firstName,
        this.lastName,
        this.description,
        this.phone,
        this.otp,
        this.email,
        this.location,
        this.latitude,
        this.longitude,
        this.role,
        this.active,
        this.lastLoggedInAt});

  User.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    description = json['description'];
    phone = json['phone'];
    otp = json['otp'];
    email = json['email'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    role = json['role'];
    active = json['active'];
    lastLoggedInAt = json['lastLoggedInAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['description'] = this.description;
    data['phone'] = this.phone;
    data['otp'] = this.otp;
    data['email'] = this.email;
    data['location'] = this.location;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['role'] = this.role;
    data['active'] = this.active;
    data['lastLoggedInAt'] = this.lastLoggedInAt;
    return data;
  }
}