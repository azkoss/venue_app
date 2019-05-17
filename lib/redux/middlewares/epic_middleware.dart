import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:venue_app/models/Bookings.dart';
import 'package:venue_app/models/VenueList.dart';
import 'package:venue_app/network/endpoints.dart';
import 'package:venue_app/network/network_adapter.dart';
import 'package:venue_app/redux/actions/helper_actions.dart';
import 'package:venue_app/redux/actions/ownerBookings_actions.dart';
import 'package:venue_app/redux/actions/playerBooking_actions.dart';
import 'package:venue_app/redux/actions/userRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

// Combined Epics
final epics = combineEpics<AppState>([requestOTP, verifyOTP, ownerBookings, venueList]);

// Individual Epics
final requestOTP = new TypedEpic<AppState, RequestOTPEpicAction>(requestOTPAPI);
final verifyOTP = new TypedEpic<AppState, VerifyOTPEpicAction>(verifyOTPAPI);
final ownerBookings = new TypedEpic<AppState, FetchOwnerBookingsEpicAction>(requestOwnerBookingList);
final venueList = new TypedEpic<AppState, FetchVenueListEpicAction>(requestVenueList);

// Epic describers
Stream<dynamic> requestOTPAPI(Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions).ofType(TypeToken<RequestOTPEpicAction>()).asyncMap(
        (action) => APIManager.request(
                    url: developmentURL + getOTPURL,
                    params: {"phone": "+91" + action.mobileNo},
                    requestType: RequestType.get,
                    contentType: ContentType.html)
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
            }).catchError((error) {
              print("Error found");
              var actionList = makeActionsListByConsideringAnyNetworkError(error);

              return TriggerMultipleActionsAction(actionList);
            }),
      );
}

Stream<dynamic> verifyOTPAPI(Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions).ofType(TypeToken<VerifyOTPEpicAction>()).asyncMap(
        (action) => APIManager.request(
                    url: developmentURL + verifyOTPURL,
                    params: {"phone": "+91" + action.mobileNo, "password": action.otp},
                    requestType: RequestType.get,
                    contentType: ContentType.html)
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
            }).catchError((error) {
              print("Error found");
              var actionList = makeActionsListByConsideringAnyNetworkError(error);

              return TriggerMultipleActionsAction(actionList);
            }),
      );
}

Stream<dynamic> requestOwnerBookingList(Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions).ofType(TypeToken<FetchOwnerBookingsEpicAction>()).asyncMap((action) {
    return APIManager.request(
      url: liveURL + ownerBookingsURL,
      requestType: RequestType.get,
      contentType: ContentType.json,
      params: null,
    ).then((response) {
      switch (response.status) {
        case ResponseStatus.error_404:
          break;
        case ResponseStatus.error_400:
          break;
        case ResponseStatus.success_200:
          print(response.data);
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
    }).catchError((error) {
      print("Error found");
      var actionList = makeActionsListByConsideringAnyNetworkError(error);
      actionList.add(UpdateOwnerBookingLoadingStatusAction(LoadingStatus.success));

      return TriggerMultipleActionsAction(actionList);
    });
  });
}

Stream<dynamic> requestVenueList(Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions).ofType(TypeToken<FetchVenueListEpicAction>()).asyncMap((action) {
    return APIManager.request(
      url: liveURL + venueListURL,
      requestType: RequestType.get,
      contentType: ContentType.json,
      params: null,
    ).then((response) {
      switch (response.status) {
        case ResponseStatus.error_404:
          break;
        case ResponseStatus.error_400:
          break;
        case ResponseStatus.success_200:
          print(response.data);
          VenueList venueList = VenueList.fromJson(response.data);
          return TriggerMultipleActionsAction(
            [
              ListVenuesAction(venueList),
              UpdateVenueListLoadingStatusAction(LoadingStatus.success),
            ],
          );
          break;
        default:
          print("Exited with default case");
          break;
      }
    }).catchError((error) {
      print("Error found");
      var actionList = makeActionsListByConsideringAnyNetworkError(error);
      actionList.add(UpdateVenueListLoadingStatusAction(LoadingStatus.success));

      return TriggerMultipleActionsAction(actionList);
    });
  });
}

// Epic Helpers
List makeActionsListByConsideringAnyNetworkError(DioError error) {
  var actions = [];
  if (error.type == DioErrorType.DEFAULT) {
    actions.add(ShowDialogueMessageAction("No network", "Please make sure you are connected to internet !"));
  }

  return actions;
}
