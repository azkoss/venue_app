import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/ownerBooking_actions.dart';
import 'package:venue_app/redux/states/ownerBookings_state.dart';

final ownerBookingsReducer = combineReducers<OwnerBookingsState>([
  // Owner Bookings updation
  TypedReducer<OwnerBookingsState, ListOwnerBookingsAction>(_updateOwnerBookingsList),
  TypedReducer<OwnerBookingsState, UpdateOwnerBookingLoadingStatusAction>(_updateOwnerBookingsLoadingStatus),
  TypedReducer<OwnerBookingsState, SetSelectedIndexForMatchesOrEvents>(_setSelectedIndex),
  TypedReducer<OwnerBookingsState, SetSelectedFilterIndex>(_setSelectedFilterIndex),
]);

OwnerBookingsState _updateOwnerBookingsList(OwnerBookingsState state, ListOwnerBookingsAction action) {
  return state.copyWith(bookings: action.ownerBookings);
}

OwnerBookingsState _updateOwnerBookingsLoadingStatus(
    OwnerBookingsState state, UpdateOwnerBookingLoadingStatusAction action) {
  return state.copyWith(loadingStatus: action.loadingStatus);
}

OwnerBookingsState _setSelectedIndex(OwnerBookingsState state, SetSelectedIndexForMatchesOrEvents action) {
  return state.copyWith(selectedIndex: action.index);
}

OwnerBookingsState _setSelectedFilterIndex(OwnerBookingsState state, SetSelectedFilterIndex action) {
  return state.copyWith(selectedFilterIndex: action.index);
}
