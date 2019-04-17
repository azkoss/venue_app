import 'package:flutter/material.dart';
import 'package:flutter_places_dialog/flutter_places_dialog.dart';
import 'package:venue_app/models/User.dart';

class UserRegistrationState {
  final User user;
  final UserFieldValidations fieldValidations;
  final UserSceneValidations sceneValidations;

  UserRegistrationState({
    @required this.user,
    this.fieldValidations,
    this.sceneValidations,
  });

  factory UserRegistrationState.initial() {
    return UserRegistrationState(
      user: User(place: PlaceDetails()),
      fieldValidations: UserFieldValidations(),
      sceneValidations: UserSceneValidations(),
    );
  }

  UserRegistrationState copyWith({
    User user,
    UserFieldValidations fieldValidations,
    UserSceneValidations sceneValidations,
  }) {
    return UserRegistrationState(
      user: user ?? this.user,
      fieldValidations: fieldValidations ?? this.fieldValidations,
      sceneValidations: sceneValidations ?? this.sceneValidations,
    );
  }
}
