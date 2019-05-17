import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/helper_actions.dart';
import 'package:venue_app/redux/states/appHelper_state.dart';

final appHelperReducer = combineReducers<AppHelperState>([
  TypedReducer<AppHelperState, ShowDialogueMessageAction>(_showDialogueMessage),
  TypedReducer<AppHelperState, ClearDialogueMessageAction>(_clearDialogueMessages),
]);

AppHelperState _showDialogueMessage(AppHelperState state, ShowDialogueMessageAction action) {
  return state.copyWith(shouldShowAlert: true, title: action.title, message: action.message);
}

AppHelperState _clearDialogueMessages(AppHelperState state, ClearDialogueMessageAction action) {
  return state.copyWith(shouldShowAlert: false, title: "", message: "");
}
