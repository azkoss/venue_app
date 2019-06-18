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
    } else if (action is ProceedToVenueListMapSceneAction) {
      _proceedToVenueMapScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Venue Info Scene Actions">
    else if (action is ProceedToVenueBookingSceneAction) {
      _proceedToVenueBookingScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Venue Booking Scene Actions">
    else if (action is ProceedToVenueSummarySceneAction) {
      _proceedToVenueSummaryScene(store, action, next);
    }
    //</editor-fold>
  };
}

//<editor-fold desc="Venue List Scene Helpers">
_proceedToVenueInfoScene(Store<AppState> store, ProceedToVenueInfoSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("venueInfo");
}

_proceedToVenueMapScene(Store<AppState> store, ProceedToVenueListMapSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("venueMap");
}

//</editor-fold>

//<editor-fold desc="Venue Info Scene Helpers">
_proceedToVenueBookingScene(Store<AppState> store, ProceedToVenueBookingSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("venueBooking");
}
//</editor-fold>

//<editor-fold desc="Venue Booking Scene Helpers">
_proceedToVenueSummaryScene(Store<AppState> store, ProceedToVenueSummarySceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("venueSummary");
}
//</editor-fold>
