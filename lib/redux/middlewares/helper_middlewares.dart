import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/helper_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

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
