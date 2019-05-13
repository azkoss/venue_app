import 'package:redux/redux.dart';
import 'package:venue_app/models/Event.dart';
import 'package:venue_app/redux/actions/eventRegistration_actions.dart';

import '../states/app_state.dart';

Middleware<AppState> eventRegistrationMiddleWare(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    //<editor-fold desc="Common Event and Event Field updation Actions">
    if (action is UpdateEventAction) {
      next(action);
    } else if (action is UpdateEventFieldValidationAction) {
      next(action);
    } else if (action is UpdateEventSceneValidationAction) {
      next(action);
    }
    //</editor-fold>

    //<editor-fold desc="Event Name Scene Actions">
    else if (action is ValidateEventNameAction) {
      _validateEventName(store, action, next);
    } else if (action is ProceedToEventDescriptionSceneAction) {
      _proceedToEventDescriptionScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Event Description Scene Actions">
    else if (action is ValidateEventDescriptionAction) {
      _validateEventDescription(store, action, next);
    } else if (action is ProceedToEventSportSceneAction) {
      _proceedToEventSportScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Event Sport Scene Actions">
    else if (action is ProceedToEventPhotosSceneAction) {
      _proceedToEventPhotosScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Event Photos Scene Actions">
    else if (action is ValidateEventPhotosAction) {
      _validateEventPhotos(store, action, next);
    } else if (action is ProceedToEventDateSceneAction) {
      _proceedToEventDateScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Event Date Scene Actions">
    else if (action is ValidateEventStartDateAction) {
      _validateEventStartDate(store, action, next);
    } else if (action is ValidateEventEndDateAction) {
      _validateEventEndDate(store, action, next);
    } else if (action is ProceedToEventCostSceneAction) {
      _proceedToEventCostScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Event Cost Scene Actions">
    else if (action is ValidateEventCostAction) {
      _validateEventCost(store, action, next);
    } else if (action is ProceedToEventAgeGroupSceneAction) {
      _proceedToEventAgeGroupScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Event Age group Scene Actions">
    else if (action is ProceedToEventNextSceneAction) {
      _proceedToEventNextScene(store, action, next);
    }
    //</editor-fold>
  };
}

//<editor-fold desc="Event Name Scene Helpers">
_validateEventName(Store<AppState> store, ValidateEventNameAction action, NextDispatcher next) {
  Event event = store.state.eventRegistrationState.event;
  EventFieldValidations validation = store.state.eventRegistrationState.fieldValidations;

  bool isValid = (event.name.length >= 4) ? true : false;
  validation.updateWith(isValidName: isValid);

  store.dispatch(UpdateEventFieldValidationAction(validation));
  _validateEventNameScene(store);
}

_validateEventNameScene(Store<AppState> store) {
  Event event = store.state.eventRegistrationState.event;
  EventSceneValidations sceneValidation = store.state.eventRegistrationState.sceneValidations;

  bool isValid = (event.name.length >= 4) ? true : false;
  sceneValidation.updateWith(isValidEventNameScene: isValid);
  store.dispatch(UpdateEventSceneValidationAction(sceneValidation));
}

_proceedToEventDescriptionScene(
    Store<AppState> store, ProceedToEventDescriptionSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("eventDescription");
}
//</editor-fold>

//<editor-fold desc="Event Description Scene Helpers">
_validateEventDescription(Store<AppState> store, ValidateEventDescriptionAction action, NextDispatcher next) {
  Event event = store.state.eventRegistrationState.event;
  EventFieldValidations validation = store.state.eventRegistrationState.fieldValidations;

  bool isValid = (event.description.length >= 10) ? true : false;
  validation.updateWith(isValidName: isValid);

  store.dispatch(UpdateEventFieldValidationAction(validation));
  _validateEventDescriptionScene(store);
}

_validateEventDescriptionScene(Store<AppState> store) {
  Event event = store.state.eventRegistrationState.event;
  EventSceneValidations sceneValidation = store.state.eventRegistrationState.sceneValidations;

  bool isValid = (event.description.length >= 10) ? true : false;
  sceneValidation.updateWith(isValidEventDescriptionScene: isValid);
  store.dispatch(UpdateEventSceneValidationAction(sceneValidation));
}

_proceedToEventSportScene(Store<AppState> store, ProceedToEventSportSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("eventSport");
}
//</editor-fold>

//<editor-fold desc="Event Sport Scene Helpers">
_proceedToEventPhotosScene(Store<AppState> store, ProceedToEventPhotosSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("eventPhotos");
}
//</editor-fold>

//<editor-fold desc="Event Photos Scene Helpers">
_validateEventPhotos(Store<AppState> store, ValidateEventPhotosAction action, NextDispatcher next) {
  _validateEventPhotosScene(store);
}

_validateEventPhotosScene(Store<AppState> store) {
  Event event = store.state.eventRegistrationState.event;
  EventSceneValidations sceneValidation = store.state.eventRegistrationState.sceneValidations;

  bool isValid = (event.photos.length >= 2) ? true : false;
  sceneValidation.updateWith(isValidEventPhotosScene: isValid);
  store.dispatch(UpdateEventSceneValidationAction(sceneValidation));
}

_proceedToEventDateScene(Store<AppState> store, ProceedToEventDateSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("eventDate");
}
//</editor-fold>

//<editor-fold desc="Event Date Scene Helpers">
_validateEventStartDate(Store<AppState> store, ValidateEventStartDateAction action, NextDispatcher next) {
  Event event = store.state.eventRegistrationState.event;
  EventFieldValidations fieldValidations = store.state.eventRegistrationState.fieldValidations;

  bool isValid = (event.startDate.isAfter(DateTime.now()) && event.startDate.isBefore(event.endDate)) ? true : false;
  fieldValidations.updateWith(isValidStartDate: isValid);
  store.dispatch(UpdateEventFieldValidationAction(fieldValidations));

  _validateEventDateScene(store);
}

_validateEventEndDate(Store<AppState> store, ValidateEventEndDateAction action, NextDispatcher next) {
  Event event = store.state.eventRegistrationState.event;
  EventFieldValidations fieldValidations = store.state.eventRegistrationState.fieldValidations;

  bool isValid = (event.endDate.isAfter(DateTime.now()) && event.endDate.isAfter(event.startDate)) ? true : false;
  fieldValidations.updateWith(isValidEndDate: isValid);
  store.dispatch(UpdateEventFieldValidationAction(fieldValidations));

  _validateEventDateScene(store);
}

_validateEventDateScene(Store<AppState> store) {
  Event event = store.state.eventRegistrationState.event;
  EventSceneValidations sceneValidation = store.state.eventRegistrationState.sceneValidations;

  bool isValidStartDate =
      (event.startDate.isAfter(DateTime.now()) && event.startDate.isBefore(event.endDate)) ? true : false;
  bool isValidEndDate =
      (event.endDate.isAfter(DateTime.now()) && event.endDate.isAfter(event.startDate)) ? true : false;
  sceneValidation.updateWith(isValidEventDateScene: isValidStartDate && isValidEndDate);
  store.dispatch(UpdateEventSceneValidationAction(sceneValidation));
}

_proceedToEventCostScene(Store<AppState> store, ProceedToEventCostSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("eventCost");
}
//</editor-fold>

//<editor-fold desc="Event Cost Scene Helpers">
_validateEventCost(Store<AppState> store, ValidateEventCostAction action, NextDispatcher next) {
  _validateEventCostScene(store);
}

_validateEventCostScene(Store<AppState> store) {
  Event event = store.state.eventRegistrationState.event;
  EventSceneValidations sceneValidation = store.state.eventRegistrationState.sceneValidations;

  bool isValid = (event.cost > 0) ? true : false;
  sceneValidation.updateWith(isValidEventCostScene: isValid);
  store.dispatch(UpdateEventSceneValidationAction(sceneValidation));
}

_proceedToEventAgeGroupScene(Store<AppState> store, ProceedToEventAgeGroupSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("eventAgeGroup");
}
//</editor-fold>

//<editor-fold desc="Event Age group Scene Helpers">
_proceedToEventNextScene(Store<AppState> store, ProceedToEventNextSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("eventName");
}
//</editor-fold>
