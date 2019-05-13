import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/redux/states/app_state.dart';

import '../../models/Venue.dart';
import '../../redux/actions/venueRegistration_actions.dart';

class VenueAmenitiesScene extends StatefulWidget {
  final Store<AppState> store;

  VenueAmenitiesScene(this.store);

  @override
  _VenueAmenitiesSceneState createState() => _VenueAmenitiesSceneState();
}

class _VenueAmenitiesSceneState extends State<VenueAmenitiesScene> {
  Amenities hh = Amenities.parking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
          converter: (store) => _ViewModel.create(store),
          builder: (BuildContext context, _ViewModel viewModel) => ListView(
                children: <Widget>[
                  buildTitle(),
                  buildDescription(),
                  buildAmenitiesList(context, viewModel),
                  buildNextButton(context, viewModel),
                ],
              )),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Text(
        "What are the amneties provided in venue?",
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
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. sed do eiusmod tempor incididunt ut labore et.",
        style: const TextStyle(
            color: const Color(0xffc7c7c7),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 16.7),
      ),
    );
  }

  Widget buildAmenitiesList(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 8.0, right: 20.0),
      child: Column(
        children: _buildAmenitiesCheckBoxes(context, viewModel),
      ),
    );
  }

  List<Widget> _buildAmenitiesCheckBoxes(BuildContext context, _ViewModel viewModel) {
    List<Widget> widgets = [];

    for (Amenities amenity in Amenities.values) {
      var row = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
//            decoration: ShapeDecoration(shape: Border.all(color: Colors.grey)),
            child: Checkbox(
              checkColor: Colors.green,
              activeColor: Colors.white10,
              value: viewModel.amenities.contains(amenity),
              onChanged: (value) {
                viewModel.addOrRemoveAmenity(amenity);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: Icon(Sport.displayIconForAmenity(amenity)),
          ),
          Text(
            Sport.displayNameForAmenity(amenity),
            style: const TextStyle(
                color: const Color(0xff000000),
                fontWeight: FontWeight.w400,
                fontFamily: "GoogleSans",
                fontStyle: FontStyle.normal,
                fontSize: 20.5),
          ),
        ],
      );

      widgets.add(row);
    }

    return widgets;
  }

  Widget buildNextButton(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(top: 30.0, right: 20.0, bottom: 20.0),
      child: Container(
        alignment: Alignment.topRight,
        child: FloatingActionButton(
          onPressed: () {
            viewModel.canProceedToNextScene ? viewModel.proceedToNextScene() : null;
          },
          backgroundColor: viewModel.canProceedToNextScene ? Colors.green : Colors.grey,
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}

class _ViewModel {
  List<Amenities> amenities;
  final Function(Amenities) addOrRemoveAmenity;

  VenueFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.amenities,
    this.addOrRemoveAmenity,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _addOrRemoveAmenity(Amenities amenity) {
      Venue venue = store.state.venueRegistrationState.venue;
      if (venue.amenities.contains(amenity)) {
        venue.amenities.remove(amenity);
      } else {
        venue.amenities.add(amenity);
      }

      store.dispatch(UpdateVenueAction(venue));
      store.dispatch(ValidateVenueAmenitiesAction());
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToVenueSportsSceneAction());
    }

    return _ViewModel(
      amenities: store.state.venueRegistrationState.venue.amenities,
      addOrRemoveAmenity: _addOrRemoveAmenity,
      fieldValidations: store.state.venueRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.venueRegistrationState.sceneValidations.isValidVenueAmenitiesScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
