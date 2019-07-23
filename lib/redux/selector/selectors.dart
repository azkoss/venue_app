import 'package:venue_app/redux/states/app_state.dart';
import 'package:venue_app/repository/app_enum_manager.dart';
import 'package:venue_app/repository/store_builder.dart';

PersistenceModel appAuthorizationValue(AppState state) =>
    PersistenceModel(status: LoginStatus.none, type: UserType.none);
// state.appAuthorizationState.authStateModel;
