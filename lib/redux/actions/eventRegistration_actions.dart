import 'package:venue_app/models/Event.dart';
import 'package:venue_app/models/events/CreateEventRequestParams.dart';

//<editor-fold desc="Common Event Details Updation Actions">
class UpdateEventAction {
  final Event event;
  UpdateEventAction(this.event);
}

class UpdateEventFieldValidationAction {
  final EventFieldValidations validations;
  UpdateEventFieldValidationAction(this.validations);
}

class UpdateEventSceneValidationAction {
  final EventSceneValidations sceneValidations;
  UpdateEventSceneValidationAction(this.sceneValidations);
}
//</editor-fold>

//<editor-fold desc="Event Name Scene Actions">
class ValidateEventNameAction {
  ValidateEventNameAction();
}

class ProceedToEventDescriptionSceneAction {
  ProceedToEventDescriptionSceneAction();
}
//</editor-fold>

//<editor-fold desc="Event Description Scene Actions">
class ValidateEventDescriptionAction {
  ValidateEventDescriptionAction();
}

class ProceedToEventSportSceneAction {
  ProceedToEventSportSceneAction();
}
//</editor-fold>

//<editor-fold desc="Event Sport Scene Actions">
class ProceedToEventPhotosSceneAction {
  ProceedToEventPhotosSceneAction();
}
//</editor-fold>

//<editor-fold desc="Event Photos Scene Actions">
class ValidateEventPhotosAction {
  ValidateEventPhotosAction();
}

class ProceedToEventDateSceneAction {
  ProceedToEventDateSceneAction();
}
//</editor-fold>

//<editor-fold desc="Event Date Scene Actions">
class ValidateEventStartDateAction {
  ValidateEventStartDateAction();
}

class ValidateEventEndDateAction {
  ValidateEventEndDateAction();
}

class ProceedToEventCostSceneAction {
  ProceedToEventCostSceneAction();
}
//</editor-fold>

//<editor-fold desc="Event Cost Scene Actions">
class ValidateEventCostAction {
  ValidateEventCostAction();
}

class ProceedToEventAgeGroupSceneAction {
  ProceedToEventAgeGroupSceneAction();
}
//</editor-fold>

//<editor-fold desc="Event AgeGroup Scene Actions">
class ProceedToEventNextSceneAction {
  ProceedToEventNextSceneAction();
}
//</editor-fold>

class EventsListEpicAction {
  final String token;

  EventsListEpicAction(this.token);
}

class CreateEventEpicAction {
  final String token;
  final CreateEventRequestParams requestParams;

  CreateEventEpicAction(this.token, this.requestParams);
}
