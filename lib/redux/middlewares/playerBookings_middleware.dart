import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/playerBooking_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

Middleware<AppState> playerBookingMiddleWare(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    //<editor-fold desc="Venue List Scene Actions">
    if (action is ListVenuesAction) {
      next(action);
    } else if (action is UpdateVenueListLoadingStatusAction) {
      next(action);
    } else if (action is ProceedToVenueInfoSceneAction) {
      _proceedToVenueInfoScene(store, action, next);
    }
    //</editor-fold>
  };
}

//<editor-fold desc="Venue List Scene Helpers">
_proceedToVenueInfoScene(Store<AppState> store, ProceedToVenueInfoSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("venueInfo");
}
//</editor-fold>
