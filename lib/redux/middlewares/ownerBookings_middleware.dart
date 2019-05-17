import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/ownerBookings_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

Middleware<AppState> ownerBookingsMiddleWare(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    //<editor-fold desc="Owner Bookings updation Actions">
    if (action is ListOwnerBookingsAction) {
      next(action);
    } else if (action is UpdateOwnerBookingLoadingStatusAction) {
      next(action);
    } else if (action is SetSelectedFilterIndex) {
      next(action);
    } else if (action is SetSelectedIndexForMatchesOrEvents) {
      next(action);
    }
    //</editor-fold>
  };
}
