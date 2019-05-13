import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/ownerBookings_actions.dart';
import 'package:venue_app/redux/states/ownerBookings_state.dart';

final ownerBookingsReducer = combineReducers<OwnerBookingsState>([
  // Owner Bookings updation
  TypedReducer<OwnerBookingsState, ListOwnerBookingsAction>(_updateOwnerBookingsList),
  TypedReducer<OwnerBookingsState, UpdateOwnerBookingLoadingStatusAction>(_updateOwnerBookingsLoadingStatus),
]);

OwnerBookingsState _updateOwnerBookingsList(OwnerBookingsState state, ListOwnerBookingsAction action) {
  return state.copyWith(bookings: action.ownerBookings);
}

OwnerBookingsState _updateOwnerBookingsLoadingStatus(
    OwnerBookingsState state, UpdateOwnerBookingLoadingStatusAction action) {
  return state.copyWith(loadingStatus: action.loadingStatus);
}
