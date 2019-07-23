import 'package:venue_app/redux/states/app_state.dart';
import 'package:venue_app/repository/store_builder.dart';

PersistenceModel appAuthorizationValue(AppState state) =>
    state.appAuthorizationState.authStateModel;
