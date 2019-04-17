import 'package:redux/redux.dart';

import '../actions/venueRegistration_actions.dart';
import '../states/venueRegistration_state.dart';

final venueRegistrationReducer = combineReducers<VenueRegistrationState>([
  // Common Venue updation
  TypedReducer<VenueRegistrationState, UpdateVenueAction>(_updateVenue),
  TypedReducer<VenueRegistrationState, UpdateVenueFieldValidationAction>(_updateVenueFieldValidation),
  TypedReducer<VenueRegistrationState, UpdateVenueSceneValidationAction>(_updateVenueSceneValidation),
]);

VenueRegistrationState _updateVenue(VenueRegistrationState state, UpdateVenueAction action) {
  return state.copyWith(venue: action.venue);
}

VenueRegistrationState _updateVenueFieldValidation(
    VenueRegistrationState state, UpdateVenueFieldValidationAction action) {
  return state.copyWith(fieldValidations: action.validations);
}

VenueRegistrationState _updateVenueSceneValidation(
    VenueRegistrationState state, UpdateVenueSceneValidationAction action) {
  return state.copyWith(sceneValidations: action.sceneValidations);
}
