import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/ownerBooking_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

Middleware<AppState> ownerBookingsMiddleWare(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    //<editor-fold desc="Owner Bookings updation Actions">
    if (action is ListOwnerBookingsAction) {
      next(action);
    } else if (action is UpdateOwnerBookingLoadingStatusAction) {
      next(action);
    } else if (action is SetSelectedSportIndex) {
      next(action);
    } else if (action is SetSelectedFilterIndex) {
      next(action);
    } else if (action is SetSelectedIndexForMatchesOrEvents) {
      next(action);
    } else if (action is ProceedToEventNameSceneAction) {
      _proceedToEventNameScene(store, action, next);
    } else if (action is ProceedToEventBookingSceneAction) {
      _proceedToEventBookingScene(store, action, next);
    }
    //</editor-fold>
  };
}

_proceedToEventNameScene(Store<AppState> store, ProceedToEventNameSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("eventName");
}

_proceedToEventBookingScene(Store<AppState> store, ProceedToEventBookingSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("eventBooking");
}
