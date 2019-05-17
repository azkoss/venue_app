import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/playerBooking_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

Middleware<AppState> venueListMiddleWare(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    //<editor-fold desc="Owner Bookings updation Actions">
    if (action is ListVenuesAction) {
      next(action);
    } else if (action is UpdateVenueListLoadingStatusAction) {
      next(action);
    }
    //</editor-fold>
  };
}
