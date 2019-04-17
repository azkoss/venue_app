import 'package:flutter_places_dialog/flutter_places_dialog.dart';

enum UserType {
  owner,
  player,
}

class User {
  PlaceDetails place;
  String mobileNo;
  String otp;
  int tutorialIndex;
  UserType userType;

  User({
    this.place,
    this.mobileNo = "",
    this.otp = "",
    this.tutorialIndex = 0,
    this.userType = UserType.owner,
  });
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
