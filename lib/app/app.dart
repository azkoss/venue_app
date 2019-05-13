import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/redux/middlewares/appState_middleware.dart';
import 'package:venue_app/redux/reducers/appState_reducer.dart';
import 'package:venue_app/redux/states/app_state.dart';
import 'package:venue_app/screens/eventRegistration/eventAgeGroup_scene.dart';
import 'package:venue_app/screens/eventRegistration/eventCost_scene.dart';
import 'package:venue_app/screens/eventRegistration/eventDate_scene.dart';
import 'package:venue_app/screens/eventRegistration/eventDescription_scene.dart';
import 'package:venue_app/screens/eventRegistration/eventName_scene.dart';
import 'package:venue_app/screens/eventRegistration/eventPhotos_scene.dart';
import 'package:venue_app/screens/eventRegistration/eventSport_scene.dart';
import 'package:venue_app/screens/home/home_scene.dart';
import 'package:venue_app/screens/userRegistration/Tutorial_scene.dart';
import 'package:venue_app/screens/userRegistration/landing_scene.dart';
import 'package:venue_app/screens/userRegistration/location_scene.dart';
import 'package:venue_app/screens/userRegistration/mobile_number_scene.dart';
import 'package:venue_app/screens/userRegistration/otp_scene.dart';
import 'package:venue_app/screens/venueRegistration/venueTimeAndPrice_scene.dart';

import '../screens/venueRegistration/venueAddress_scene.dart';
import '../screens/venueRegistration/venueAmenities_scene.dart';
import '../screens/venueRegistration/venueAvailableSports_scene.dart';
import '../screens/venueRegistration/venueDetails_scene.dart';
import '../screens/venueRegistration/venueLocation_scene.dart';
import '../screens/venueRegistration/venuePhotos_scene.dart';

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
        debugShowCheckedModeBanner: false,
        title: 'Venue App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: StoreBuilder<AppState>(
            onInit: (store) => {}, builder: (BuildContext context, Store<AppState> store) => LocationScene(store)),
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
          return TutorialScene(store);
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
    }
  }
}
