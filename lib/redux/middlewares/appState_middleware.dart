import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:venue_app/redux/actions/eventRegistration_actions.dart';
import 'package:venue_app/redux/actions/helper_actions.dart';
import 'package:venue_app/redux/actions/ownerBooking_actions.dart';
import 'package:venue_app/redux/actions/playerBooking_actions.dart';
import 'package:venue_app/redux/middlewares/epic_middleware.dart';
import 'package:venue_app/redux/middlewares/eventRegistration_middleware.dart';
import 'package:venue_app/redux/middlewares/helper_middlewares.dart';
import 'package:venue_app/redux/middlewares/ownerBookings_middleware.dart';
import 'package:venue_app/redux/middlewares/playerBookings_middleware.dart';

import '../actions/userRegistration_actions.dart';
import '../actions/venueRegistration_actions.dart';
import '../middlewares/userRegistration_middleware.dart';
import '../middlewares/venueRegistration_middleware.dart';
import '../states/app_state.dart';

List<Middleware<AppState>> appStateMiddleware([AppState state]) {
  final epicMiddleware = epicLoginRegister;
  final combineActionsMiddleWare = combineMultipleActionsMiddleWare(state);
  final appHelperStateMiddleWare = appHelperMiddleWare(state);
  final userRegistrationStateMiddleware = userRegistrationMiddleware(state);
  final venueRegistrationStateMiddleware = venueRegistrationMiddleWare(state);
  final eventRegistrationStateMiddleware = eventRegistrationMiddleWare(state);
  final ownerBookingsStateMiddleware = ownerBookingsMiddleWare(state);
  final playerBookingStateMiddleware = playerBookingMiddleWare(state);

  return [
    // Epic Middleware for network calls
    EpicMiddleware<AppState>(epicMiddleware),

    // Middleware for triggering multiple actions at once
    TypedMiddleware<AppState, TriggerMultipleActionsAction>(combineActionsMiddleWare),

    // Middleware for app helper functions
    TypedMiddleware<AppState, ShowDialogueMessageAction>(appHelperStateMiddleWare),
    TypedMiddleware<AppState, ClearDialogueMessageAction>(appHelperStateMiddleWare),

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
    TypedMiddleware<AppState, OTPVerificationSuccessAction>(userRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToLandingSceneAction>(userRegistrationStateMiddleware),

    //Landing Scene
    TypedMiddleware<AppState, ProceedToTutorialSceneAction>(userRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToVenueLocationSceneAction>(userRegistrationStateMiddleware),

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

    // Common Event Updation
    TypedMiddleware<AppState, UpdateEventAction>(eventRegistrationStateMiddleware),
    TypedMiddleware<AppState, UpdateEventFieldValidationAction>(eventRegistrationStateMiddleware),
    TypedMiddleware<AppState, UpdateEventSceneValidationAction>(eventRegistrationStateMiddleware),

    //Event Name Scene
    TypedMiddleware<AppState, ValidateEventNameAction>(eventRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToEventDescriptionSceneAction>(eventRegistrationStateMiddleware),

    //Event Description Scene
    TypedMiddleware<AppState, ValidateEventDescriptionAction>(eventRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToEventSportSceneAction>(eventRegistrationStateMiddleware),

    //Event Sport Scene
    TypedMiddleware<AppState, ProceedToEventPhotosSceneAction>(eventRegistrationStateMiddleware),

    //Event Photos Scene
    TypedMiddleware<AppState, ValidateEventPhotosAction>(eventRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToEventDateSceneAction>(eventRegistrationStateMiddleware),

    //Event Photos Scene
    TypedMiddleware<AppState, ValidateEventStartDateAction>(eventRegistrationStateMiddleware),
    TypedMiddleware<AppState, ValidateEventEndDateAction>(eventRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToEventCostSceneAction>(eventRegistrationStateMiddleware),

    //Event Cost Scene
    TypedMiddleware<AppState, ValidateEventCostAction>(eventRegistrationStateMiddleware),
    TypedMiddleware<AppState, ProceedToEventAgeGroupSceneAction>(eventRegistrationStateMiddleware),

    //Event AgeGroup Scene
    TypedMiddleware<AppState, ProceedToEventNextSceneAction>(eventRegistrationStateMiddleware),

    // Owner Bookings Scene
    TypedMiddleware<AppState, ListOwnerBookingsAction>(ownerBookingsStateMiddleware),
    TypedMiddleware<AppState, UpdateOwnerBookingLoadingStatusAction>(ownerBookingsStateMiddleware),
    TypedMiddleware<AppState, SetSelectedSportIndex>(ownerBookingsStateMiddleware),
    TypedMiddleware<AppState, SetSelectedFilterIndex>(ownerBookingsStateMiddleware),
    TypedMiddleware<AppState, SetSelectedIndexForMatchesOrEvents>(ownerBookingsStateMiddleware),
    TypedMiddleware<AppState, ProceedToEventNameSceneAction>(ownerBookingsStateMiddleware),
    TypedMiddleware<AppState, ProceedToEventBookingSceneAction>(ownerBookingsStateMiddleware),

    // Venue List Scene
    TypedMiddleware<AppState, ListVenuesAction>(playerBookingStateMiddleware),
    TypedMiddleware<AppState, UpdateVenueListLoadingStatusAction>(playerBookingStateMiddleware),
    TypedMiddleware<AppState, ProceedToVenueInfoSceneAction>(playerBookingStateMiddleware),
    TypedMiddleware<AppState, ProceedToVenueBookingSceneAction>(playerBookingStateMiddleware),
    TypedMiddleware<AppState, ProceedToVenueSummarySceneAction>(playerBookingStateMiddleware),
    TypedMiddleware<AppState, ProceedToVenueListMapSceneAction>(playerBookingStateMiddleware),
  ];
}
