import 'package:flutter/material.dart';
import 'package:flutter_places_dialog/flutter_places_dialog.dart';

import '../../models/Venue.dart';

class VenueRegistrationState {
  final Venue venue;
  final VenueFieldValidations fieldValidations;
  final VenueSceneValidations sceneValidations;

  VenueRegistrationState({@required this.venue, this.fieldValidations, this.sceneValidations});

  factory VenueRegistrationState.initial() {
    return VenueRegistrationState(
      venue: Venue(location: PlaceDetails(), photos: [], amenities: [], sports: []),
      fieldValidations: VenueFieldValidations(),
      sceneValidations: VenueSceneValidations(),
    );
  }

  VenueRegistrationState copyWith(
      {Venue venue, VenueFieldValidations fieldValidations, VenueSceneValidations sceneValidations}) {
    return VenueRegistrationState(
        venue: venue ?? this.venue,
        fieldValidations: fieldValidations ?? this.fieldValidations,
        sceneValidations: sceneValidations ?? this.sceneValidations);
  }
}
