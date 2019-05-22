import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/playerBooking_actions.dart';
import 'package:venue_app/redux/states/playerBooking_state.dart';

final playerBookingReducer = combineReducers<PlayerBookingState>([
  // Owner Bookings updation
  TypedReducer<PlayerBookingState, ListVenuesAction>(_updateVenueList),
  TypedReducer<PlayerBookingState, UpdateVenueListLoadingStatusAction>(_updateOwnerBookingsLoadingStatus),
]);

PlayerBookingState _updateVenueList(PlayerBookingState state, ListVenuesAction action) {
  return state.copyWith(venueList: action.venueList);
}

PlayerBookingState _updateOwnerBookingsLoadingStatus(
    PlayerBookingState state, UpdateVenueListLoadingStatusAction action) {
  return state.copyWith(loadingStatus: action.loadingStatus);
}
