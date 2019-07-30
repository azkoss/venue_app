class SignUpRequestParams {
  String firstName;
  String lastName;
  String description;
  String email;
  String phone;
  String location;
  double latitude;
  double longitude;
  int role;

  SignUpRequestParams(
      {this.firstName,
        this.lastName,
        this.description,
        this.email,
        this.phone,
        this.location,
        this.latitude,
        this.longitude,
        this.role});

  SignUpRequestParams.fromJson(Map<String, dynamic> json) {
    firstName = json['firstname'];
    lastName = json['lastname'];
    description = json['description'];
    email = json['email'];
    phone = json['phone'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname'] = this.firstName;
    data['lastname'] = this.lastName;
    data['description'] = this.description;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['location'] = this.location;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['role'] = this.role;
    return data;
  }
}