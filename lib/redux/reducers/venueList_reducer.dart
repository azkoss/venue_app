import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/playerBooking_actions.dart';
import 'package:venue_app/redux/states/venueList_state.dart';

final venueListReducer = combineReducers<VenueListState>([
  // Owner Bookings updation
  TypedReducer<VenueListState, ListVenuesAction>(_updateVenueList),
  TypedReducer<VenueListState, UpdateVenueListLoadingStatusAction>(_updateOwnerBookingsLoadingStatus),
]);

VenueListState _updateVenueList(VenueListState state, ListVenuesAction action) {
  return state.copyWith(venueList: action.venueList);
}

VenueListState _updateOwnerBookingsLoadingStatus(VenueListState state, UpdateVenueListLoadingStatusAction action) {
  return state.copyWith(loadingStatus: action.loadingStatus);
}
