import 'dart:async';

import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:venue_app/models/Bookings.dart';
import 'package:venue_app/models/registration/SignUpResponse.dart';
import 'package:venue_app/network/endpoints.dart';
import 'package:venue_app/network/network_adapter.dart';
import 'package:venue_app/redux/actions/helper_actions.dart';
import 'package:venue_app/redux/actions/ownerBookings_actions.dart';
import 'package:venue_app/redux/actions/userRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

final epics = combineEpics<AppState>([sampleEpic, requestOTPEpic, verifyOTPEpic, signUpUserEpic]);

final sampleEpic = new TypedEpic<AppState, FetchOwnerBookingsEpicAction>(performNetworkCall);
final requestOTPEpic = new TypedEpic<AppState, RequestOTPEpicAction>(requestOTPAPI);
final verifyOTPEpic = new TypedEpic<AppState, VerifyOTPEpicAction>(verifyOTPAPI);
final signUpUserEpic = new TypedEpic<AppState, CompleteUserRegistrations>(signUpUserAPI);

// Network call
Stream<dynamic> performNetworkCall(Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions).ofType(TypeToken<FetchOwnerBookingsEpicAction>()).asyncMap(
        (action) => APIManager.request(
                    url: baseURL + "hello1",
         //    params: action.request.toJson(),
                    requestType: RequestType.get)
                .then((response) {
              switch (response.status) {
                case ResponseStatus.error_404:
                  break;
                case ResponseStatus.error_400:
                  break;
                case ResponseStatus.success_200:
                  OwnerBookings ownerBookings = OwnerBookings.fromJson(response.data);
                  return TriggerMultipleActionsAction(
                    [
                      ListOwnerBookingsAction(ownerBookings),
                      UpdateOwnerBookingLoadingStatusAction(LoadingStatus.success),
                    ],
                  );
                  break;
                default:
                  print("Exited with default case");
                  break;
              }
            }).catchError((error) => UpdateOwnerBookingLoadingStatusAction(LoadingStatus.error)),
      );
}

Stream<dynamic> requestOTPAPI(Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions).ofType(TypeToken<RequestOTPEpicAction>()).asyncMap(
        (action) => APIManager.request(
                    url: developmentURL + getOTP,
                    params: {"phone": "+91" + action.mobileNo},
                    requestType: RequestType.get)
                .then((response) {
              switch (response.status) {
                case ResponseStatus.error_404:
                  break;
                case ResponseStatus.error_400:
                  break;
                case ResponseStatus.success_200:
                  print(response.data);
                  break;
                default:
                  print("Exited with default case");
                  break;
              }
            }).catchError((error) => print("Catch error")),
      );
}

Stream<dynamic> verifyOTPAPI(Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions).ofType(TypeToken<VerifyOTPEpicAction>()).asyncMap(
        (action) => APIManager.request(
                    url: developmentURL + verifyOTP,
                    params: {"phone": "+91" + action.mobileNo, "password": action.otp},
                    requestType: RequestType.get)
                .then((response) {
              switch (response.status) {
                case ResponseStatus.error_404:
                  break;
                case ResponseStatus.error_400:
                  break;
                case ResponseStatus.success_200:
                  String accessToken = response.data["access"];

                  return TriggerMultipleActionsAction(
                    [
                      OTPVerificationSuccessAction(accessToken),
                    ],
                  );
                  break;
                default:
                  print("Exited with default case");
                  break;
              }
            }).catchError((error) => print("Catch error")),
      );
}

Stream<dynamic> signUpUserAPI(Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions).ofType(TypeToken<CompleteUserRegistrations>()).asyncMap(
        (action) => APIManager.request(
        url: developmentURL + signUp,
        params: action.requestParams.toJson(),
        requestType: RequestType.post)
        .then((response) {
      switch (response.status) {
        case ResponseStatus.error_404:
          break;
        case ResponseStatus.error_400:
          break;
        case ResponseStatus.success_200:
          SignUpResponse signUpResponse = SignUpResponse.fromJson(response.data);
          break;
        default:
          print("Exited with default case");
          break;
      }
    }).catchError((error) => print("Catch error")),
  );
}
