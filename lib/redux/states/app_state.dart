import 'package:flutter/material.dart';

import '../states/userRegistration_state.dart';
import '../states/venueRegistration_state.dart';

class AppState {
  final UserRegistrationState userRegistrationState;
  final VenueRegistrationState venueRegistrationState;

  const AppState({
    this.userRegistrationState,
    this.venueRegistrationState,
  });

  AppState.initialState()
      : userRegistrationState = UserRegistrationState.initial(),
        venueRegistrationState = VenueRegistrationState.initial();

  AppState copyWith({UserRegistrationState userRegistrationState}) {
    return new AppState(
      userRegistrationState: userRegistrationState ?? this.userRegistrationState,
      venueRegistrationState: venueRegistrationState ?? this.venueRegistrationState,
    );
  }

  // AppState.fromJson(Map json) : items = (json["items"] as List);

  // Map toJson() => {"items": items};
}

class Keys {
  static final navigationKey = new GlobalKey<NavigatorState>();
}
