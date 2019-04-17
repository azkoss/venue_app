import 'package:redux/redux.dart';

import '../actions/userRegistration_actions.dart';
import '../actions/venueRegistration_actions.dart';
import '../middlewares/userRegistration_middleware.dart';
import '../middlewares/venueRegistration_middleware.dart';
import '../states/app_state.dart';

List<Middleware<AppState>> appStateMiddleware([AppState state]) {
  final userRegistrationStateMiddleware = userRegistrationMiddleware(state);
  final venueRegistrationStateMiddleware = venueRegistrationMiddleWare(state);

  return [
    // Common User Updation
    TypedMiddleware<AppState, UpdateUserAction>(userRegistrationStateMiddleware),
    TypedMiddleware<AppState, UpdateUserFieldValidationAction>(userRegistrationStateMiddleware),
    TypedMiddleware<AppState, UpdateUserSceneValidationAction>(userRegistrationStateMiddleware),
    // Location Scene
    TypedMiddleware<AppState, ValidateUserLocationAction>(userRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToUserMobileNoSceneAction>(userRegistrationStateMiddleware),
    // MobileNo Scene
    TypedMiddleware<AppState, ValidateMobileNoAction>(userRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToOTPSceneAction>(userRegistrationStateMiddleware),
    //OTP Scene
    TypedMiddleware<AppState, ValidateOTPAction>(userRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToLandingSceneAction>(userRegistrationStateMiddleware),
    //Landing Scene
    TypedMiddleware<AppState, ProceedToTutorialSceneAction>(userRegistrationStateMiddleware),
    //Tutorial Scene
    TypedMiddleware<AppState, ProceedToOwnerOrPlayerSceneAction>(userRegistrationStateMiddleware),

    // Common Venue Updation
    TypedMiddleware<AppState, UpdateVenueAction>(venueRegistrationStateMiddleware),
    TypedMiddleware<AppState, UpdateVenueFieldValidationAction>(venueRegistrationStateMiddleware),
    TypedMiddleware<AppState, UpdateVenueSceneValidationAction>(venueRegistrationStateMiddleware),
    //Venue Location Scene
    TypedMiddleware<AppState, ValidateVenueLocationAction>(venueRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToVenueAddressSceneAction>(venueRegistrationStateMiddleware),
    //Venue Address Scene
    TypedMiddleware<AppState, ValidateVenueNameAction>(venueRegistrationStateMiddleware),
    TypedMiddleware<AppState, ValidateVenueAddressLine1Action>(venueRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToVenueDetailsSceneAction>(venueRegistrationStateMiddleware),
    //Venue Description Scene
    TypedMiddleware<AppState, ValidateVenueDescriptionAction>(venueRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToVenuePhotosSceneAction>(venueRegistrationStateMiddleware),
    //Venue Photos Scene
    TypedMiddleware<AppState, ValidateVenuePhotosAction>(venueRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToVenueAmenitiesSceneAction>(venueRegistrationStateMiddleware),
    //Venue Amenities Scene
    TypedMiddleware<AppState, ValidateVenueAmenitiesAction>(venueRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToVenueSportsSceneAction>(venueRegistrationStateMiddleware),
    //Venue Amenities Scene
    TypedMiddleware<AppState, ValidateVenueSportsAction>(venueRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToVenueTimeSlotSceneAction>(venueRegistrationStateMiddleware),
  ];
}
