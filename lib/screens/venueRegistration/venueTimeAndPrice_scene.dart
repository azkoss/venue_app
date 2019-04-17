import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/redux/states/app_state.dart';

import '../../models/Venue.dart';
import '../../redux/actions/venueRegistration_actions.dart';

class VenueTimeAndPriceScene extends StatelessWidget {
  final Store<AppState> store;

  VenueTimeAndPriceScene(this.store);

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
  List photos;
  final Function(File, int) insertPhoto;

  VenueFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.photos,
    this.insertPhoto,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _insertPhoto(File file, int index) {
      Venue venue = store.state.venueRegistrationState.venue;
      if (venue.photos.length == 0 || index > venue.photos.length - 1) {
        venue.photos.add(file);
      } else {
        venue.photos[index] = file;
      }

      store.dispatch(UpdateVenueAction(venue));
      store.dispatch(ValidateVenuePhotosAction());
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToVenueAmenitiesSceneAction());
    }

    return _ViewModel(
      photos: store.state.venueRegistrationState.venue.photos,
      insertPhoto: _insertPhoto,
      fieldValidations: store.state.venueRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.venueRegistrationState.sceneValidations.isValidVenuePhotosScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
