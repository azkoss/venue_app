import 'package:flutter/material.dart';
import 'package:venue_app/redux/states/eventRegistration_state.dart';
import 'package:venue_app/redux/states/ownerBookings_state.dart';
import 'package:venue_app/redux/states/playerBooking_state.dart';

import '../states/userRegistration_state.dart';
import '../states/venueRegistration_state.dart';
import 'appHelper_state.dart';

class AppState {
  final AppHelperState helperState;
  final UserRegistrationState userRegistrationState;
  final VenueRegistrationState venueRegistrationState;
  final EventRegistrationState eventRegistrationState;
  final OwnerBookingsState ownerBookingsState;
  final PlayerBookingState playerBookingsState;

  const AppState(
      {this.helperState,
      this.userRegistrationState,
      this.venueRegistrationState,
      this.eventRegistrationState,
      this.ownerBookingsState,
      this.playerBookingsState});

  AppState.initialState()
      : helperState = AppHelperState.initial(),
        userRegistrationState = UserRegistrationState.initial(),
        venueRegistrationState = VenueRegistrationState.initial(),
        eventRegistrationState = EventRegistrationState.initial(),
        ownerBookingsState = OwnerBookingsState.initial(),
        playerBookingsState = PlayerBookingState.initial();

  AppState copyWith(
      {AppHelperState helperState,
      UserRegistrationState userRegistrationState,
      VenueRegistrationState venueRegistrationState,
      EventRegistrationState eventRegistrationState,
      OwnerBookingsState ownerBookingsState,
      PlayerBookingState playerBookingsState}) {
    return new AppState(
        helperState: helperState ?? this.helperState,
        userRegistrationState: userRegistrationState ?? this.userRegistrationState,
        venueRegistrationState: venueRegistrationState ?? this.venueRegistrationState,
        eventRegistrationState: eventRegistrationState ?? this.eventRegistrationState,
        ownerBookingsState: ownerBookingsState ?? this.ownerBookingsState,
        playerBookingsState: playerBookingsState ?? this.playerBookingsState);
  }

  // AppState.fromJson(Map json) : items = (json["items"] as List);

  // Map toJson() => {"items": items};
}

class Keys {
  static final navigationKey = new GlobalKey<NavigatorState>();
}
