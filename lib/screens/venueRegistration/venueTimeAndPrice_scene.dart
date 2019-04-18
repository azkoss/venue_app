import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/redux/states/app_state.dart';

import '../../models/Venue.dart';

class VenueTimeAndPriceScene extends StatefulWidget {
  final Store<AppState> store;
  Sport currentSelectedSport;

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
                ListView(
                  children: <Widget>[
                    buildTitle(),
                    buildDescription(),
                    buildSubTitle1(),
                    buildSportsList(context, viewModel),
                    buildSubTitle2(),
                    buildSubTitle3(),
                  ],
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
    if (widget.currentSelectedSport == null) {
      widget.currentSelectedSport = viewModel.availableSports[0];
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        height: 70.0,
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
                        opacity: widget.currentSelectedSport == sport ? 1.0 : 0.3,
                        child: sport.displayIcon(),
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        Text(
                          sport.displayName(),
                          style: TextStyle(
                              color: widget.currentSelectedSport == sport ? Colors.black : Color(0xffe8e8e8),
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
                            color: widget.currentSelectedSport == sport ? Colors.green : Colors.transparent,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  widget.currentSelectedSport = viewModel.availableSports[index];
                  setState(() {});
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

  Widget buildLetsGoButton(BuildContext context, _ViewModel viewModel) {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      left: 0.0,
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
    );
  }
}

class _ViewModel {
  List<Sport> availableSports;

  VenueFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.availableSports,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
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
      fieldValidations: store.state.venueRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.venueRegistrationState.sceneValidations.isValidVenueTimeSlotAndPriceScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
