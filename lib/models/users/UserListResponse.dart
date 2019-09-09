class UsersListResponse {
  int code;
  String status;
  String description;
  List<Users> users;

  UsersListResponse({this.code, this.status, this.description, this.users});

  UsersListResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    description = json['description'];
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['description'] = this.description;
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
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

  Users(
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

  Users.fromJson(Map<String, dynamic> json) {
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