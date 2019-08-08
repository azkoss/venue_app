import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/helper_actions.dart';
import 'package:venue_app/redux/middlewares/appState_middleware.dart';
import 'package:venue_app/redux/reducers/appState_reducer.dart';
import 'package:venue_app/redux/states/app_state.dart';

import 'package:venue_app/screens/home/eventBooking_scene.dart';

import 'package:venue_app/screens/home/home_scene.dart';
import 'package:venue_app/screens/home/owner/eventRegistration/eventAgeGroup_scene.dart';
import 'package:venue_app/screens/home/owner/eventRegistration/eventCost_scene.dart';
import 'package:venue_app/screens/home/owner/eventRegistration/eventDate_scene.dart';
import 'package:venue_app/screens/home/owner/eventRegistration/eventDescription_scene.dart';
import 'package:venue_app/screens/home/owner/eventRegistration/eventName_scene.dart';
import 'package:venue_app/screens/home/owner/eventRegistration/eventPhotos_scene.dart';
import 'package:venue_app/screens/home/owner/eventRegistration/eventSport_scene.dart';


import 'package:venue_app/screens/home/player/venueBooking_scene.dart';
import 'package:venue_app/screens/home/player/venueInfo_scene.dart';
import 'package:venue_app/screens/home/player/venueListMap_scene.dart';
import 'package:venue_app/screens/home/player/venueSummary_scene.dart';
import 'package:venue_app/screens/home/venueRegistration/venueAddress_scene.dart';
import 'package:venue_app/screens/home/venueRegistration/venueAmenities_scene.dart';
import 'package:venue_app/screens/home/venueRegistration/venueAvailableSports_scene.dart';
import 'package:venue_app/screens/home/venueRegistration/venueDetails_scene.dart';
import 'package:venue_app/screens/home/venueRegistration/venueLocation_scene.dart';
import 'package:venue_app/screens/home/venueRegistration/venuePhotos_scene.dart';
import 'package:venue_app/screens/home/venueRegistration/venueTimeAndPrice_scene.dart';

import 'package:venue_app/screens/userRegistration/Tutorial_scene.dart';
import 'package:venue_app/screens/userRegistration/landing_scene.dart';
import 'package:venue_app/screens/userRegistration/mobile_number_scene.dart';
import 'package:venue_app/screens/userRegistration/otp_scene.dart';




class VenueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Store<AppState> store = Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: appStateMiddleware(),
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            child: child,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'Venue App',
        theme: ThemeData(
          primarySwatch: Colors.green,
          splashColor: Colors.green,
        ),

        home:
        Scaffold(body:MobileNumberScene(store)


//        AppStoreBuilder(builder: (context, stateModel){
//          switch(stateModel.status){
//            case LoginStatus.loggedIn:
//              if (stateModel.type == UserType.owner) LandingScene(store);
//              else LandingScene(store);
//              break;
//            case LoginStatus.loggedOut:
//              LandingScene(store);
//              break;
//            case LoginStatus.none:
//              LandingScene(store);
//              break;
//          }},
//
//        ),
        ),

        navigatorKey: Keys.navigationKey,
        onGenerateRoute: (routeSettings) => routes(routeSettings, store),
      ),
    );
  }

  Route routes(RouteSettings settings, Store store) {
    if (settings.name == "mobileNo") {
      return MaterialPageRoute(
        builder: (context) {
          return MobileNumberScene(store);
        },
      );
    } else if (settings.name == "otp") {
      return MaterialPageRoute(
        builder: (context) {
          return OTPScene(store);
        },
      );
    } else if (settings.name == "landing") {
      return MaterialPageRoute(
        builder: (context) {
          return LandingScene(store);
        },
      );
    } else if (settings.name == "home") {
      return MaterialPageRoute(
        builder: (context) {
          return HomeScene(store);
        },
      );
    } else if (settings.name == "tutorial") {
      return MaterialPageRoute(
        builder: (context) {
          return  TutorialScene(store);
        },
      );
    } else if (settings.name == "venueLocation") {
      return MaterialPageRoute(
        builder: (context) {
          return VenueLocationScene(store);
        },
      );
    } else if (settings.name == "venueAddress") {
      return MaterialPageRoute(
        builder: (context) {
          return VenueAddressScene(store);
        },
      );
    } else if (settings.name == "venueDetails") {
      return MaterialPageRoute(
        builder: (context) {
          return VenueDetailsScene(store);
        },
      );
    } else if (settings.name == "venuePhotos") {
      return MaterialPageRoute(
        builder: (context) {
          return VenuePhotosScene(store);
        },
      );
    } else if (settings.name == "venueAmenities") {
      return MaterialPageRoute(
        builder: (context) {
          return VenueAmenitiesScene(store);
        },
      );
    } else if (settings.name == "venueSports") {
      return MaterialPageRoute(
        builder: (context) {
          return VenueAvailableSportsScene(store);
        },
      );
    } else if (settings.name == "venueTimeAndPrice") {
      return MaterialPageRoute(
        builder: (context) {
          return VenueTimeAndPriceScene(store);
        },
      );
    } else if (settings.name == "eventName") {
      return MaterialPageRoute(
        builder: (context) {
          return EventNameScene(store);
        },
      );
    } else if (settings.name == "eventDescription") {
      return MaterialPageRoute(
        builder: (context) {
          return EventDescriptionScene(store);
        },
      );
    } else if (settings.name == "eventSport") {
      return MaterialPageRoute(
        builder: (context) {
          return EventSportScene(store);
        },
      );
    } else if (settings.name == "eventPhotos") {
      return MaterialPageRoute(
        builder: (context) {
          return EventPhotosScene(store);
        },
      );
    } else if (settings.name == "eventDate") {
      return MaterialPageRoute(
        builder: (context) {
          return EventDateScene(store);
        },
      );
    } else if (settings.name == "eventCost") {
      return MaterialPageRoute(
        builder: (context) {
          return EventCostScene(store);
        },
      );
    } else if (settings.name == "eventAgeGroup") {
      return MaterialPageRoute(
        builder: (context) {
          return EventAgeGroupScene(store);
        },
      );
    } else if (settings.name == "venueInfo") {
      return MaterialPageRoute(
        builder: (context) {
          return VenueInfoScene(store);
        },
      );
    } else if (settings.name == "eventBooking") {
      return MaterialPageRoute(
        builder: (context) {
          return EventBookingScene(store);
        },
      );
    } else if (settings.name == "venueListMap") {
      return MaterialPageRoute(
        builder: (context) {
          return VenueBookingScene(store);
        },
      );
    } else if (settings.name == "venueBooking") {
      return MaterialPageRoute(
        builder: (context) {
          return VenueBookingScene(store);
        },
      );
    } else if (settings.name == "venueSummary") {
      return MaterialPageRoute(
        builder: (context) {
          return VenueSummaryScene(store);
        },
      );
    } else if (settings.name == "venueMap") {
      return MaterialPageRoute(
        builder: (context) {
          return VenueListMapScene(store);
        },
      );
    }
  }
}

showAlertDialogueForApp(BuildContext context, Store<AppState> store) {
  String title = store.state.helperState.title;
  String message = store.state.helperState.message;
  store.dispatch(ClearDialogueMessageAction());

  Future.delayed(Duration.zero, () {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],
          );
        });
  });
}
