import 'dart:convert';

import 'package:flutter_places_dialog/flutter_places_dialog.dart';

enum UserType1 {
  owner,
  player,
}

class User {
  String id;
  PlaceDetails place;
  String mobileNo;
  String otp;
  int tutorialIndex;
  UserType1 userType;

  User({
    this.id,
    this.place,
    this.mobileNo = "",
    this.otp = "",
    this.tutorialIndex = 0,
    this.userType = UserType1.owner,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => new User(
      id: json["id"],
      place: json["id"],
      mobileNo: json["name"],
      otp: json["image"],
      userType: json["userType"] == "owner" ? UserType1.owner : UserType1.player);

  Map<String, dynamic> toJson() => {
        "latitude": place.location.latitude.toString(),
        "longitude": place.location.longitude.toString(),
        "mobileNo": mobileNo,
        "userType": userType == UserType1.owner ? "owner" : "player",
      };
}

class UserFieldValidations {
  bool isValidPlace;
  bool isValidMobileNo;
  bool isValidOTP;

  UserFieldValidations({
    this.isValidPlace = true,
    this.isValidMobileNo = true,
    this.isValidOTP = true,
  });

  updateWith({bool isValidPlace, bool isValidMobileNo, bool isValidOTP}) {
    this.isValidPlace = isValidPlace ?? this.isValidPlace;
    this.isValidMobileNo = isValidMobileNo ?? this.isValidMobileNo;
    this.isValidOTP = isValidOTP ?? this.isValidOTP;
  }
}

class UserSceneValidations {
  bool isValidUserLocationScene;
  bool isValidUserMobileNoScene;
  bool isValidUserOTPScene;

  UserSceneValidations({
    this.isValidUserLocationScene = false,
    this.isValidUserMobileNoScene = false,
    this.isValidUserOTPScene = false,
  });

  updateWith({
    bool isValidUserLocationScene,
    bool isValidUserMobileNoScene,
    bool isValidUserOTPScene,
  }) {
    this.isValidUserLocationScene = isValidUserLocationScene ?? this.isValidUserLocationScene;
    this.isValidUserMobileNoScene = isValidUserMobileNoScene ?? this.isValidUserMobileNoScene;
    this.isValidUserOTPScene = isValidUserOTPScene ?? this.isValidUserOTPScene;
  }
}
