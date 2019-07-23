import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/helper_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';
import 'package:venue_app/repository/store_builder.dart';
import 'package:venue_app/repository/strings.dart';
import 'package:venue_app/singleton/singleton.dart';

Middleware<AppState> combineMultipleActionsMiddleWare(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    //<editor-fold desc="Dispatching multiple Actions">
    if (action is TriggerMultipleActionsAction) {
      for (action in action.actions) {
        store.dispatch(action);
        next(action);
      }
    }
    //</editor-fold>
  };
}

Middleware<AppState> _appAuthStateCheck(AppState state) {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    if (action is AppAuthStateCheckAction) {

    }
  };
}
