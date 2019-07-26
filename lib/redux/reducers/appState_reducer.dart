import 'package:venue_app/redux/reducers/eventRegistration_reducer.dart';
import 'package:venue_app/redux/reducers/ownerBookings_reducer.dart';

import '../reducers/userRegistration_reducer.dart';
import '../reducers/venueRegistration_reducer.dart';
import '../states/app_state.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    userRegistrationState:
        userRegistrationReducer(state.userRegistrationState, action),
    venueRegistrationState:
        venueRegistrationReducer(state.venueRegistrationState, action),
    eventRegistrationState:
        eventRegistrationReducer(state.eventRegistrationState, action),
    ownerBookingsState: ownerBookingsReducer(state.ownerBookingsState, action),
  );
}
