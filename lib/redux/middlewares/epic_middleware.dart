import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:venue_app/models/Bookings.dart';
import 'package:venue_app/models/VenueList.dart';
import 'package:venue_app/models/registration/SignUpResponse.dart';
import 'package:venue_app/models/signin/SignInResponse.dart';
import 'package:venue_app/models/users/UserListResponse.dart';
import 'package:venue_app/models/users/UserProfileResponse.dart';
import 'package:venue_app/network/endpoints.dart';
import 'package:venue_app/network/network_adapter.dart';
import 'package:venue_app/redux/actions/eventRegistration_actions.dart';
import 'package:venue_app/redux/actions/helper_actions.dart';
import 'package:venue_app/redux/actions/ownerBooking_actions.dart';
import 'package:venue_app/redux/actions/playerBooking_actions.dart';
import 'package:venue_app/redux/actions/signIn_actions.dart';
import 'package:venue_app/redux/actions/userRegistration_actions.dart';
import 'package:venue_app/redux/actions/user_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

// Combined Epics

final epics = combineEpics<AppState>(
    [requestOTP, verifyOTP, venueList, signUpUserEpic]);


// Individual Epics
final requestOTP = new TypedEpic<AppState, RequestOTPEpicAction>(requestOTPAPI);
final verifyOTP = new TypedEpic<AppState, VerifyOTPEpicAction>(verifyOTPAPI);

final ownerBookings = new TypedEpic<AppState, FetchOwnerBookingsEpicAction>(requestOwnerBookingList);
final venueList = new TypedEpic<AppState, FetchVenueListEpicAction>(requestVenueList);

final signUpUserEpic =
new TypedEpic<AppState, CompleteUserRegistrationsEpicAction>(signUpUserAPI);


// Epic describers
Stream<dynamic> requestOTPAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
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

              var actionList =
                  makeActionsListByConsideringAnyNetworkError(error);


              return TriggerMultipleActionsAction(actionList);
            }),
      );
}

Stream<dynamic> verifyOTPAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions).ofType(TypeToken<VerifyOTPEpicAction>()).asyncMap(
        (action) => APIManager.request(
                    url: developmentURL + verifyOTPURL,

                    params: {
                      "phone": "+91" + action.mobileNo,
                      "password": action.otp
                    },

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

Stream<dynamic> requestVenueList(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<FetchVenueListEpicAction>())
      .asyncMap((action) {
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

//<editor-fold desc="User Sign-In Epic Actions (Sign-up, Sign-in, Sign-out)">
Stream<dynamic> signUpUserAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
                    url: signUpURL,
                    contentType: ContentType.json,
                    headers: {"Content-Type": "application/json",},
                    params: action.requestParams.toJson(),
                    requestType: RequestType.post)
                .then((response) {
              dynamic value = checkStatus(response);
              if (value != null) {
                SignUpResponse signUpResponse = SignUpResponse.fromJson(value);
                if (signUpResponse.code == 201) {
                  action.onSuccessCallback();
                }
              }
            }).catchError((error) =>
                    print("Catch error- in sign up" + error.toString())),
      );
}

Stream<dynamic> signInAPI(Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<SignInEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
                    url: signInURL,
                    contentType: ContentType.json,
                    params: action.requestParams.toJson(),
                    headers: {
                      "Content-Type": "application/json",
                    },
                    requestType: RequestType.post)
                .then((response) {
              dynamic value = checkStatus(response);
              if (value != null) {
                SignInResponse signInResponse = SignInResponse.fromJson(value);
                //TODO Handle Response
              }
            }).catchError((error) =>
                    print("Catch error- in sign up" + error.toString())),
      );
}

Stream<dynamic> signOutAPI(Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
  // TODO Change Action type
      .ofType(TypeToken<SignOutEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: signOutURL,
        contentType: ContentType.json,
        headers: {
          "Content-Type": "application/json",
          "token": action.userToken
        },
        params:{"":""},
        requestType: RequestType.post)
        .then((response) {
      dynamic value = checkStatus(response);
      if (value != null) {
        SignInResponse signInResponse = SignInResponse.fromJson(value);
        //TODO : Handle Sign-Out Response
      }
    }).catchError((error) =>
        print("Catch error- in sign up" + error.toString())),
  );
}

//</editor-fold>

//<editor-fold desc="User list and profile Epic Actions (getUserList, getProfile)">
Stream<dynamic> getUsersAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<GetUsersEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: usersURL,
        contentType: ContentType.json,
        headers: {
          "Content-Type": "application/json",
          "token" : action.token
        },
        requestType: RequestType.get)
        .then((response) {
      dynamic value = checkStatus(response);
      if (value != null) {
        UsersListResponse usersListResponse = UsersListResponse.fromJson(value);
      }
    }).catchError((error) =>
        print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> getUserProfileAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Change Action class
  return Observable(actions)
      .ofType(TypeToken<GetUserProfileEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: profileURL,
        contentType: ContentType.json,
        headers: {
          "token": action.token
        },
        requestType: RequestType.get)
        .then((response) {
      dynamic value = checkStatus(response);
      if (value != null) {
        UserProfileResponse userProfileResponse = UserProfileResponse.fromJson(value);
      }
    }).catchError((error) =>
        print("Catch error- in sign up" + error.toString())),
  );
}
//</editor-fold>

//<editor-fold desc="User Image Epic Actions (create, get, details and delete)">
Stream<dynamic> getUserImageListsAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<UserImageListEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: getUserImageListURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        headers: {
          "Content-Type": "application/json",
          "token": action.token
        }).then((response) {
      //TODO Not getting Response in postman
      dynamic value = checkStatus(response);
      if (value != null) {

      }
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> getUserImageDetailsAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<UserImageDetailsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: userImageDetailsURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        params: {
          "url": "https://miro.medium.com/max/700/1*gXSoA4l0UVufh0C6IG2aWA.jpeg"
        },
        headers: {
          "Content-Type": "application/json",
          "token": action.token
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> createUserImageAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CreateUserImageEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: createUserImageURL,
        contentType: ContentType.json,
        requestType: RequestType.post,
        params: {
          "url": action.imageUrl
        },
        headers: {
          "Content-Type": "application/json",
          "token": action.token
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> deleteUserImageAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<DeleteUserImageEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: deleteUserImageURL,
        contentType: ContentType.json,
        requestType: RequestType.delete,
        params: {
          "url": action.imageUrl
        },
        headers: {
          "Content-Type": "application/json",
          "token": action.token
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}
//</editor-fold>

//<editor-fold desc="Event Epic Actions (getEvent, createEvent, eventDetails, deleteEvent)">
Stream<dynamic> getEventsListAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<EventsListEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
                url: getEventsURL,
                contentType: ContentType.json,
                requestType: RequestType.get,
                headers: {
                  "Content-Type": "application/json",
                  "token": action.token
                }).then((response) {
              dynamic value = checkStatus(response);
              if (value != null) {
                //TODO Add model class in events package
                //TODO Its left unfinished due to NUll fields in Response
              }
            }).catchError(
                (error) => print("Catch error- in sign up" + error.toString())),
      );
}



Stream<dynamic> getEventDetailsAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<EventsListEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
                url: eventDetailsURL,
                contentType: ContentType.json,
                requestType: RequestType.get,
                params: {
                  "id": "event id"
                },
                headers: {
                  "Content-Type": "application/json",
                  "token": action.token
                }).then((response) {
              //TODO Change Response Type
              dynamic value = checkStatus(response);
              if (value != null) {}
            }).catchError(
                (error) => print("Catch error- in sign up" + error.toString())),
      );
}

Stream<dynamic> createEventAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CreateEventEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: createNewEventURL,
        contentType: ContentType.json,
        requestType: RequestType.post,
        params:action.requestParams.toJson(),
        headers: {
          "Content-Type": "application/json",
          "token":action.token
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> deleteAnEventAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: deleteEventURL,
        contentType: ContentType.json,
        requestType: RequestType.delete,
        params: {
          "id": 1
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}
//</editor-fold>

//<editor-fold desc="Event's Image Epic Actions(getImageList, details, create and delete)">
Stream<dynamic> getEventImagesAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: getEventImageListURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        params: {
          "event": 1
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> createEventImageAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: createEventImageURL,
        contentType: ContentType.json,
        requestType: RequestType.post,
        params: {
          "event": 1,
          "url": "https://miro.medium.com/max/700/1*gXSoA4l0UVufh0C6IG2aWA.jpeg"
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> getImageDetailsAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: userImageDetailsURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        params: {
          "id": 1,
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> deleteEventsImageAPI(
    //TODO Need to change Action Generic Type
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: deleteEventImageURL,
        contentType: ContentType.json,
        requestType: RequestType.delete,
        params: {
          "event": 1,
          "id": 2
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}
//</editor-fold>

//<editor-fold desc="venue Epic Actions(getVenueList,venue create, venue update and delete)">
Stream<dynamic> getVenueListAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: getVenueListURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> createVenueAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: createVenueURL,
        contentType: ContentType.json,
        requestType: RequestType.post,
        params: {
          "name": "Venue 1",
          "address1": "Address 1",
          "address2": "Address 2",
          "description": "Test description",
          "location": "Kochi",
          "latitude": 76,
          "longitude": 91
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> updateVenueAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: updateVenueURL,
        contentType: ContentType.json,
        requestType: RequestType.patch,
        params: {
          "id": 1,
          "name": "Venue 1",
          "address1": "Address 1",
          "address2": "Address 2",
          "description": "Test description",
          "location": "Kochi",
          "latitude": 76,
          "longitude": 91
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> deleteVenueAPI(
    //TODO Need to change Action Generic Type
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: deleteVenueURL,
        contentType: ContentType.json,
        requestType: RequestType.delete,
        params: {
          "id": 1
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}
//</editor-fold>

//<editor-fold desc="Venue Sport Epic Actions(list, details, create, update and delete)">
Stream<dynamic> getVenueSportsListAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: getVenueSportListURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        params: {
          "venue": 1
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> createVenueSportAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: createVenueSportURL,
        contentType: ContentType.json,
        requestType: RequestType.post,
        params:{
          "venue": 1,
          "sport": 1,
          "description": "test description"
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> venueSportDetailAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: venueSportDetailURL,
        contentType: ContentType.json,
        requestType: RequestType.patch,
        params: {
          "id": 1,
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> updateVenueSportAPI(
    //TODO Need to change Action Generic Type
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: updateVenueSportURL,
        contentType: ContentType.json,
        requestType: RequestType.delete,
        params: {
          "id": 3,
          "venue": 1,
          "sport": 1,
          "description": "Test description"
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> deleteVenueSportAPI(
    //TODO Need to change Action Generic Type
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: deleteVenueSportURL,
        contentType: ContentType.json,
        requestType: RequestType.delete,
        params: {
          "id": 3,
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}
//</editor-fold>

//<editor-fold desc="Venue Rating Epic Actions(Ratings, new rating, update rating and delete)">
Stream<dynamic> getVenueRatingAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: getVenueRatingURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        params: {
          "venue": 1
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> createVenueRatingAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: createVenueRatingURL,
        contentType: ContentType.json,
        requestType: RequestType.post,
        params: {
          "venue": 1,
          "rating":1,
          "description": "test 2"
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> venueRatingDetailAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: venueRatingDetailURL,
        contentType: ContentType.json,
        requestType: RequestType.patch,
        params: {
          "id": 1,
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> deleteVenueRatingAPI(
    //TODO Need to change Action Generic Type
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: deleteVenueRatingURL,
        contentType: ContentType.json,
        requestType: RequestType.delete,
        params: {
          "id": 1
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}
//</editor-fold>

//<editor-fold desc="Venue Amenity Epic Actions(list, details, create, update and delete)">
//TODO Need to verify APIs
//</editor-fold>

//<editor-fold desc="Booking Epic Actions(getBookings, details, create and delete)">
Stream<dynamic> getBookingsAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: bookingsURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> getBookingDetailsAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: bookingDetailsURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        params: {
          "id": 1
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> createBookingAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: createBookingURL,
        contentType: ContentType.json,
        requestType: RequestType.post,
        params: {
          "name": "Event 2",
          "startAt": 2,
          "endAt": 2,
          "description": "Test event",
          "pricePerHour": 100,
          "ageGroup": 1,
          "venue": 1,
          "sport": 1
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> deleteBookingAPI(
    //TODO Need to change Action Generic Type
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: deleteBookingURL,
        contentType: ContentType.json,
        requestType: RequestType.post,
        params: {
          "id": 1
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

//</editor-fold>

//<editor-fold desc="Amenity Epic Actions(get amenities, amenity details,create amenities, update amenities and delete)">
Stream<dynamic> getAmenitiesAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: amenitiesListURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> getAmenityDetailsAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: amenityDetailsURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        params: {
          "id": 1
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> createAmenityAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: createAmenityURL,
        contentType: ContentType.json,
        requestType: RequestType.post,
        params: {
          "name": "Free WiFi",
          "description": "Free WiFi access"
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> updateAmenityAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: updateAmenityURL,
        contentType: ContentType.json,
        requestType: RequestType.patch,
        params: {
          "id": 3,
          "name": "Free 2",
          "description": "Free 2"
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> deleteAmenityAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: deleteAmenityURL,
        contentType: ContentType.json,
        requestType: RequestType.delete,
        params: {
          "id": 3
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

//</editor-fold>

//<editor-fold desc="Ground Epic Actions(get grounds, ground details,create ground, update ground and delete)">
Stream<dynamic> getGroundsAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: groundListURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> getGroundDetailsAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: groundDetailsURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        params: {
          "id": 1
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> createGroundAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: createGroundURL,
        contentType: ContentType.json,
        requestType: RequestType.post,
        params: {
          "name": "Football Ground",
          "description": "Football Ground - 7s"
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> updateGroundAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: updateGroundURL,
        contentType: ContentType.json,
        requestType: RequestType.patch,
        params: {
          "id": 1,
          "name": "Football Ground",
          "description": "Football Ground - 7s"
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> deleteGroundAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: deleteGroundURL,
        contentType: ContentType.json,
        requestType: RequestType.delete,
        params: {
          "id": 3
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}
//</editor-fold>

//<editor-fold desc="Ground Image Epic Actions(get ground's Images, image details,create ground's image and delete image)">
Stream<dynamic> getGroundImagesAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: groundImageListURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        params: {
          "ground": 1
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> getGroundImageDetailsAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: groundDetailsURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        params: {
          "url": "https://miro.medium.com/max/700/1*gXSoA4l0UVufh0C6IG2aWA.jpeg"
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> createGroundImageAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: createGroundURL,
        contentType: ContentType.json,
        requestType: RequestType.post,
        params: {
          "ground": 1,
          "url": "https://miro.medium.com/max/700/1*gXSoA4l0UVufh0C6IG2aWA.jpeg"
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> deleteGroundImageAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: deleteGroundImageURL,
        contentType: ContentType.json,
        requestType: RequestType.delete,
        params: {
          "url": "https://miro.medium.com/max/700/1*gXSoA4l0UVufh0C6IG2aWA.jpeg"
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}
//</editor-fold>

//<editor-fold desc="Sports Epic Actions(get sports list, sport details,create sport and delete)">
Stream<dynamic> getSportsAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: sportsListURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> getSportDetailsAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: sportDetailsURL,
        contentType: ContentType.json,
        requestType: RequestType.get,
        params: {
          "id": 1
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> createSportAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: createSportURL,
        contentType: ContentType.json,
        requestType: RequestType.post,
        params: {
          "name": "FootBall",
          "description": "des",
          "ground": 1
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> updateSportAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: updateSportURL,
        contentType: ContentType.json,
        requestType: RequestType.patch,
        params: {
          "id": 3,
          "name": "Free 2",
          "description": "Free 2"
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

Stream<dynamic> deleteSportAPI(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  //TODO Need to change Action Generic Type
  return Observable(actions)
      .ofType(TypeToken<CompleteUserRegistrationsEpicAction>())
      .asyncMap(
        (action) => APIManager.request(
        url: deleteSportURL,
        contentType: ContentType.json,
        requestType: RequestType.delete,
        params: {
          "id": 3
        },
        headers: {
          "Content-Type": "application/json",
          "token": "Add user token"
        }).then((response) {
      //TODO Change Response Type
      dynamic value = checkStatus(response);
      if (value != null) {}
    }).catchError(
            (error) => print("Catch error- in sign up" + error.toString())),
  );
}

//</editor-fold>

dynamic checkStatus(ResponseModel rm) {
  switch (rm.status) {
    case ResponseStatus.error_404:
      break;
    case ResponseStatus.error_400:
      break;
    case ResponseStatus.success_200:
      return rm.data;
      break;
    case ResponseStatus.error_300:
      print("status 300");
      break;
    default:
      print("Exited with default case");
      break;
  }
  return null;
}



// Epic Helpers
List makeActionsListByConsideringAnyNetworkError(DioError error) {
  var actions = [];
  if (error.type == DioErrorType.DEFAULT) {

    actions.add(ShowDialogueMessageAction(
        "No network", "Please make sure you are connected to internet !"));

  }

  return actions;
}
