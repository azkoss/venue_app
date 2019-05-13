import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/eventRegistration_actions.dart';
import 'package:venue_app/redux/states/eventRegistration_state.dart';

final eventRegistrationReducer = combineReducers<EventRegistrationState>([
  // Common Event updation
  TypedReducer<EventRegistrationState, UpdateEventAction>(_updateVenue),
  TypedReducer<EventRegistrationState, UpdateEventFieldValidationAction>(_updateEventFieldValidation),
  TypedReducer<EventRegistrationState, UpdateEventSceneValidationAction>(_updateEventSceneValidation),
]);

EventRegistrationState _updateVenue(EventRegistrationState state, UpdateEventAction action) {
  return state.copyWith(event: action.event);
}

EventRegistrationState _updateEventFieldValidation(
    EventRegistrationState state, UpdateEventFieldValidationAction action) {
  return state.copyWith(fieldValidations: action.validations);
}

EventRegistrationState _updateEventSceneValidation(
    EventRegistrationState state, UpdateEventSceneValidationAction action) {
  return state.copyWith(sceneValidations: action.sceneValidations);
}
