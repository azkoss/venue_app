import 'package:redux/redux.dart';

import '../actions/userRegistration_actions.dart';
import '../states/userRegistration_state.dart';

final userRegistrationReducer = combineReducers<UserRegistrationState>([
  // Common User updation
  TypedReducer<UserRegistrationState, UpdateUserAction>(_updateVenue),
  TypedReducer<UserRegistrationState, UpdateUserFieldValidationAction>(_updateVenueFieldValidation),
  TypedReducer<UserRegistrationState, UpdateUserSceneValidationAction>(_updateVenueSceneValidation),
]);

UserRegistrationState _updateVenue(UserRegistrationState state, UpdateUserAction action) {
  return state.copyWith(user: action.user);
}

UserRegistrationState _updateVenueFieldValidation(UserRegistrationState state, UpdateUserFieldValidationAction action) {
  return state.copyWith(fieldValidations: action.fieldValidations);
}

UserRegistrationState _updateVenueSceneValidation(UserRegistrationState state, UpdateUserSceneValidationAction action) {
  return state.copyWith(sceneValidations: action.sceneValidations);
}
