import 'package:flutter/material.dart';
import 'package:venue_app/redux/states/app_authorization_state.dart';
import 'package:venue_app/redux/states/eventRegistration_state.dart';
import 'package:venue_app/redux/states/ownerBookings_state.dart';

import '../states/userRegistration_state.dart';
import '../states/venueRegistration_state.dart';

class AppState {
  final UserRegistrationState userRegistrationState;
  final VenueRegistrationState venueRegistrationState;
  final EventRegistrationState eventRegistrationState;
  final OwnerBookingsState ownerBookingsState;
  final AuthorizationState appAuthorizationState;

  const AppState(
      {this.userRegistrationState,
      this.venueRegistrationState,
      this.eventRegistrationState,
      this.ownerBookingsState,
      this.appAuthorizationState});

  AppState.initialState()
      : userRegistrationState = UserRegistrationState.initial(),
        venueRegistrationState = VenueRegistrationState.initial(),
        eventRegistrationState = EventRegistrationState.initial(),
        ownerBookingsState = OwnerBookingsState.initial(),
        appAuthorizationState = AuthorizationState.initial();

  AppState copyWith({UserRegistrationState userRegistrationState}) {
    return new AppState(
      userRegistrationState:
          userRegistrationState ?? this.userRegistrationState,
      venueRegistrationState:
          venueRegistrationState ?? this.venueRegistrationState,
      eventRegistrationState:
          eventRegistrationState ?? this.eventRegistrationState,
      ownerBookingsState: ownerBookingsState ?? this.ownerBookingsState,
      appAuthorizationState:
          appAuthorizationState ?? this.appAuthorizationState,
    );
  }

  // AppState.fromJson(Map json) : items = (json["items"] as List);

  // Map toJson() => {"items": items};
}

class Keys {
  static final navigationKey = new GlobalKey<NavigatorState>();
}
