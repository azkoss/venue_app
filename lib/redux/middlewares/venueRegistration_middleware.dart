import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/venueRegistration_actions.dart';

import '../../models/Venue.dart';
import '../states/app_state.dart';

Middleware<AppState> venueRegistrationMiddleWare(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    //<editor-fold desc="Common Venue and Venue Field updation Actions">
    if (action is UpdateVenueAction) {
      next(action);
    } else if (action is UpdateVenueFieldValidationAction) {
      next(action);
    } else if (action is UpdateVenueSceneValidationAction) {
      next(action);
    }
    //</editor-fold>

    //<editor-fold desc="Venue Location Scene Actions">
    else if (action is ValidateVenueLocationAction) {
      _validateVenueLocation(store, action, next);
    } else if (action is ProceedToVenueAddressSceneAction) {
      _proceedToVenueAddressScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Venue Address Scene Actions">
    else if (action is ValidateVenueNameAction) {
      _validateVenueName(store, action, next);
    } else if (action is ValidateVenueAddressLine1Action) {
      _validateVenueAddressLine1(store, action, next);
    } else if (action is ProceedToVenueDetailsSceneAction) {
      _proceedToVenueDetailsScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Venue Description Actions">
    else if (action is ValidateVenueDescriptionAction) {
      _validateVenueDescription(store, action, next);
    } else if (action is ProceedToVenuePhotosSceneAction) {
      _proceedToVenuePhotosScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Venue Photos Actions">
    else if (action is ValidateVenuePhotosAction) {
      _validateVenuePhotos(store, action, next);
    } else if (action is ProceedToVenueAmenitiesSceneAction) {
      _proceedToVenueAmenitiesScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Venue Amenities Actions">
    else if (action is ValidateVenueAmenitiesAction) {
      _validateVenueAmenities(store, action, next);
    } else if (action is ProceedToVenueSportsSceneAction) {
      _proceedToVenueSportsScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Venue Sports Actions">
    else if (action is ValidateVenueSportsAction) {
      _validateVenueSports(store, action, next);
    } else if (action is ProceedToVenueTimeSlotSceneAction) {
      _proceedToVenueTimeSlotAndPriceScene(store, action, next);
    }
    //</editor-fold>
  };
}

//<editor-fold desc="Venue Location Scene Helpers">
_validateVenueLocation(Store<AppState> store, ValidateVenueLocationAction action, NextDispatcher next) {
  Venue venue = store.state.venueRegistrationState.venue;
  VenueFieldValidations validation = store.state.venueRegistrationState.fieldValidations;

  if (venue.location.address.isNotEmpty) {
    validation.updateWith(isValidLocation: true);
  }

  store.dispatch(UpdateVenueFieldValidationAction(validation));
  _validateVenueLocationScene(store);
}

_validateVenueLocationScene(Store<AppState> store) {
  Venue venue = store.state.venueRegistrationState.venue;
  VenueSceneValidations sceneValidation = store.state.venueRegistrationState.sceneValidations;

  if (venue.location.address.isNotEmpty) {
    sceneValidation.updateWith(isValidVenueLocationScene: true);
    store.dispatch(UpdateVenueSceneValidationAction(sceneValidation));
  }
}

_proceedToVenueAddressScene(Store<AppState> store, ProceedToVenueAddressSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("venueAddress");
}
//</editor-fold>

//<editor-fold desc="Venue Address Scene Helpers">
_validateVenueName(Store<AppState> store, ValidateVenueNameAction action, NextDispatcher next) {
  Venue venue = store.state.venueRegistrationState.venue;
  VenueFieldValidations validation = store.state.venueRegistrationState.fieldValidations;
  bool isValid = (venue.venueName.length > 4) ? true : false;
  validation.updateWith(isValidName: isValid);

  store.dispatch(UpdateVenueFieldValidationAction(validation));
  _validateVenueAddressScene(store);
}

_validateVenueAddressLine1(Store<AppState> store, ValidateVenueAddressLine1Action action, NextDispatcher next) {
  Venue venue = store.state.venueRegistrationState.venue;
  VenueFieldValidations validation = store.state.venueRegistrationState.fieldValidations;
  bool isValid = (venue.addressLine1.length > 4) ? true : false;
  validation.updateWith(isValidAddressLine1: isValid);

  store.dispatch(UpdateVenueFieldValidationAction(validation));
  _validateVenueAddressScene(store);
}

_validateVenueAddressScene(Store<AppState> store) {
  Venue venue = store.state.venueRegistrationState.venue;
  VenueSceneValidations sceneValidation = store.state.venueRegistrationState.sceneValidations;

  if (venue.venueName.length > 4 && venue.addressLine1.length > 4) {
    sceneValidation.updateWith(isValidVenueAddressScene: true);
    store.dispatch(UpdateVenueSceneValidationAction(sceneValidation));
  }
}

_proceedToVenueDetailsScene(Store<AppState> store, ProceedToVenueDetailsSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("venueDetails");
}
//</editor-fold>

//<editor-fold desc="Venue Description Scene Helpers">
_validateVenueDescription(Store<AppState> store, ValidateVenueDescriptionAction action, NextDispatcher next) {
  Venue venue = store.state.venueRegistrationState.venue;
  VenueFieldValidations validation = store.state.venueRegistrationState.fieldValidations;

  if (venue.description.length > 10) {
    validation.updateWith(isValidDescription: true);
  }

  store.dispatch(UpdateVenueFieldValidationAction(validation));
  _validateVenueDescriptionScene(store);
}

_validateVenueDescriptionScene(Store<AppState> store) {
  Venue venue = store.state.venueRegistrationState.venue;
  VenueSceneValidations sceneValidation = store.state.venueRegistrationState.sceneValidations;

  if (venue.description.length > 10) {
    sceneValidation.updateWith(isValidVenueDetailsScene: true);
    store.dispatch(UpdateVenueSceneValidationAction(sceneValidation));
  }
}

_proceedToVenuePhotosScene(Store<AppState> store, ProceedToVenuePhotosSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("venuePhotos");
}
//</editor-fold>

//<editor-fold desc="Venue Photos Scene Helpers">
_validateVenuePhotos(Store<AppState> store, ValidateVenuePhotosAction action, NextDispatcher next) {
  _validateVenuePhotosScene(store);
}

_validateVenuePhotosScene(Store<AppState> store) {
  Venue venue = store.state.venueRegistrationState.venue;
  VenueSceneValidations sceneValidation = store.state.venueRegistrationState.sceneValidations;

  if (venue.photos.length >= 2) {
    sceneValidation.updateWith(isValidVenuePhotosScene: true);
    store.dispatch(UpdateVenueSceneValidationAction(sceneValidation));
  }
}

_proceedToVenueAmenitiesScene(Store<AppState> store, ProceedToVenueAmenitiesSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("venueAmenities");
}
//</editor-fold>

//<editor-fold desc="Venue Amenities Scene Helpers">
_validateVenueAmenities(Store<AppState> store, ValidateVenueAmenitiesAction action, NextDispatcher next) {
  _validateVenueAmenitiesScene(store);
}

_validateVenueAmenitiesScene(Store<AppState> store) {
  Venue venue = store.state.venueRegistrationState.venue;
  VenueSceneValidations sceneValidation = store.state.venueRegistrationState.sceneValidations;

  bool isValid = (venue.amenities.length >= 1) ? true : false;
  sceneValidation.updateWith(isValidVenueAmenitiesScene: isValid);
  store.dispatch(UpdateVenueSceneValidationAction(sceneValidation));
}

_proceedToVenueSportsScene(Store<AppState> store, ProceedToVenueSportsSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("venueSports");
}
//</editor-fold>

//<editor-fold desc="Venue Sports Scene Helpers">
_validateVenueSports(Store<AppState> store, ValidateVenueSportsAction action, NextDispatcher next) {
  _validateVenueSportsScene(store);
}

_validateVenueSportsScene(Store<AppState> store) {
  Venue venue = store.state.venueRegistrationState.venue;
  VenueSceneValidations sceneValidation = store.state.venueRegistrationState.sceneValidations;

  bool isValid = (venue.sports.length >= 1) ? true : false;
  sceneValidation.updateWith(isValidVenueSportsScene: isValid);
  store.dispatch(UpdateVenueSceneValidationAction(sceneValidation));
}

_proceedToVenueTimeSlotAndPriceScene(
    Store<AppState> store, ProceedToVenueTimeSlotSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("venueTimeAndPrice");
}
//</editor-fold>
