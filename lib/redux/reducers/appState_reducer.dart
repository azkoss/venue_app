import '../reducers/userRegistration_reducer.dart';
import '../reducers/venueRegistration_reducer.dart';
import '../states/app_state.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    userRegistrationState: userRegistrationReducer(state.userRegistrationState, action),
    venueRegistrationState: venueRegistrationReducer(state.venueRegistrationState, action),
  );
}
