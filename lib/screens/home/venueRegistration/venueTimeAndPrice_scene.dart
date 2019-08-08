import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/redux/actions/venueRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

import 'package:venue_app/models/Venue.dart';


class VenueTimeAndPriceScene extends StatefulWidget {
  final Store<AppState> store;

  List<String> weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

  VenueTimeAndPriceScene(this.store);

  @override
  _VenueTimeAndPriceSceneState createState() => _VenueTimeAndPriceSceneState();
}

class _VenueTimeAndPriceSceneState extends State<VenueTimeAndPriceScene> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: ListView(
                    children: <Widget>[
                      buildTitle(),
                      buildDescription(),
                      buildSubTitle1(),
                      buildSportsList(context, viewModel),
                      buildSubTitle2(),
                      buildGroundList(context, viewModel),
                      buildSubTitle3(),
                      buildWeekList(context, viewModel),
                    ],
                  ),
                ),
                buildLetsGoButton(context, viewModel),
              ],
            ),
      ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Text(
        "Select your available time slots and pricing",
        style: const TextStyle(
            color: const Color(0xff000000),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 33.0),
      ),
    );
  }

  Widget buildDescription() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: Text(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. sed do eiusmod tempor incididunt ut",
        style: const TextStyle(
            color: const Color(0xffc7c7c7),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 16.7),
      ),
    );
  }

  Widget buildSubTitle1() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0),
      child: Text(
        "Select your sport",
        style: const TextStyle(
            color: const Color(0xffe8e8e8),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget buildSportsList(BuildContext context, _ViewModel viewModel) {
    Sport currentSelectedSport = viewModel.availableSports.first;
    if (viewModel.currentSelectedSport != null) {
      currentSelectedSport = viewModel.currentSelectedSport;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        height: 60.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: viewModel.availableSports.length,
          itemBuilder: (context, index) {
            var sport = viewModel.availableSports[index];

            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Opacity(
                        opacity: currentSelectedSport == sport ? 1.0 : 0.3,
                        child: Sport.displayIcon(sport.name),
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        Text(
                          Sport.displayName(sport.name),
                          style: TextStyle(
                              color: currentSelectedSport == sport ? Colors.black : Color(0xffe8e8e8),
                              fontWeight: FontWeight.w700,
                              fontFamily: "GoogleSans",
                              fontStyle: FontStyle.normal,
                              fontSize: 20.5),
                        ),
                        Positioned(
                          left: 2.0,
                          bottom: 0.0,
                          child: Container(
                            height: 2.0,
                            width: 30.0,
                            color: currentSelectedSport == sport ? Colors.green : Colors.transparent,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  viewModel.setSelectedSport(sport);
                  viewModel.setSelectedGround(sport.groundNames.first);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildSubTitle2() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0),
      child: Text(
        "Select your play area",
        style: const TextStyle(
            color: const Color(0xffe8e8e8),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget buildGroundList(BuildContext context, _ViewModel viewModel) {
    String currentSelectedGround = viewModel.currentSelectedSport.groundNames.first;
    if (viewModel.currentSelectedGround != null) {
      currentSelectedGround = viewModel.currentSelectedGround;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        height: 60.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: viewModel.currentSelectedSport.groundNames.length,
          itemBuilder: (context, index) {
            var ground = viewModel.currentSelectedSport.groundNames[index];

            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Text(
                          ground,
                          style: TextStyle(
                              color: currentSelectedGround == ground ? Colors.black : Color(0xffe8e8e8),
                              fontWeight: FontWeight.w700,
                              fontFamily: "GoogleSans",
                              fontStyle: FontStyle.normal,
                              fontSize: 20.5),
                        ),
                        Positioned(
                          left: 2.0,
                          bottom: 0.0,
                          child: Container(
                            height: 2.0,
                            width: 30.0,
                            color: currentSelectedGround == ground ? Colors.green : Colors.transparent,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  viewModel.setSelectedGround(ground);
                  viewModel.setSelectedDay(widget.weekDays.first);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildSubTitle3() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0),
      child: Text(
        "Add your time slot and pricing",
        style: const TextStyle(
            color: const Color(0xffe8e8e8),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget buildWeekList(BuildContext context, _ViewModel viewModel) {
    String currentSelectedDay = widget.weekDays.first;
    if (viewModel.currentSelectedDay != null) {
      currentSelectedDay = viewModel.currentSelectedDay;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        height: 60.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.weekDays.length,
          itemBuilder: (context, index) {
            var day = widget.weekDays[index];

            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Text(
                          day,
                          style: TextStyle(
                              color: currentSelectedDay == day ? Colors.black : Color(0xffe8e8e8),
                              fontWeight: FontWeight.w700,
                              fontFamily: "GoogleSans",
                              fontStyle: FontStyle.normal,
                              fontSize: 20.5),
                        ),
                        Positioned(
                          left: 2.0,
                          bottom: 0.0,
                          child: Container(
                            height: 2.0,
                            width: 30.0,
                            color: currentSelectedDay == day ? Colors.green : Colors.transparent,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  viewModel.setSelectedDay(day);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildLetsGoButton(BuildContext context, _ViewModel viewModel) {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      left: 0.0,
      child: InkWell(
        onTap: (){

        },
        child: Container(
          height: 60.0,
          color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LET’S GO",
                style: const TextStyle(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w500,
                    fontFamily: "GoogleSans",
                    fontStyle: FontStyle.normal,
                    fontSize: 23.3),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  List<Sport> availableSports;
  Sport currentSelectedSport;
  String currentSelectedGround;
  String currentSelectedDay;
  Function(Sport sport) setSelectedSport;
  Function(String ground) setSelectedGround;
  Function(String day) setSelectedDay;

  VenueFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.availableSports,
    this.currentSelectedSport,
    this.currentSelectedGround,
    this.currentSelectedDay,
    this.setSelectedSport,
    this.setSelectedGround,
    this.setSelectedDay,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _setSelectedSport(Sport sport) {
      Venue venue = store.state.venueRegistrationState.venue;
      venue.currentSelectedSport = sport;

      store.dispatch(UpdateVenueAction(venue));
    }

    _setSelectedGround(String ground) {
      Venue venue = store.state.venueRegistrationState.venue;
      venue.currentSelectedGround = ground;

      store.dispatch(UpdateVenueAction(venue));
    }

    _setSelectedDay(String day) {
      Venue venue = store.state.venueRegistrationState.venue;
      venue.currentSelectedDay = day;

      store.dispatch(UpdateVenueAction(venue));
    }

//    _availableGroundForSport(Sports sport) {
//      Venue venue = store.state.venueRegistrationState.venue;
//      if (venue.photos.length == 0 || index > venue.photos.length - 1) {
//        venue.photos.add(file);
//      } else {
//        venue.photos[index] = file;
//      }
//
//      store.dispatch(UpdateVenueAction(venue));
//      store.dispatch(ValidateVenuePhotosAction());
//    }

    _proceedToNextScene() {
      print("Proceed");
//      store.dispatch(ProceedToVenueAmenitiesSceneAction());
    }

    return _ViewModel(
      availableSports: store.state.venueRegistrationState.venue.sports,
      currentSelectedSport: store.state.venueRegistrationState.venue.currentSelectedSport ??
          store.state.venueRegistrationState.venue.sports.first,
      currentSelectedGround: store.state.venueRegistrationState.venue.currentSelectedGround ??
          store.state.venueRegistrationState.venue.sports.first.groundNames.first,
      currentSelectedDay: store.state.venueRegistrationState.venue.currentSelectedDay,
      setSelectedSport: _setSelectedSport,
      setSelectedGround: _setSelectedGround,
      setSelectedDay: _setSelectedDay,
      fieldValidations: store.state.venueRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.venueRegistrationState.sceneValidations.isValidVenueTimeSlotAndPriceScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
