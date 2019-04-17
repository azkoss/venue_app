import 'package:flutter/material.dart';
import 'package:flutter_places_dialog/flutter_places_dialog.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/redux/states/app_state.dart';

import '../../models/Venue.dart';
import '../../redux/actions/venueRegistration_actions.dart';

class VenueLocationScene extends StatefulWidget {
  final Store<AppState> store;

  VenueLocationScene(this.store);

  @override
  _VenueLocationSceneState createState() => _VenueLocationSceneState();
}

class _VenueLocationSceneState extends State<VenueLocationScene> {
  final TextEditingController controller = TextEditingController();

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
          converter: (store) => _ViewModel.create(store),
          builder: (BuildContext context, _ViewModel viewModel) => ListView(
                children: <Widget>[
                  buildTitle(),
                  buildDescription(),
                  buildTextField(context, viewModel),
                  buildNextButton(context, viewModel),
                ],
              )),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Text(
        "Where is your sports venue located?",
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

  Widget buildTextField(BuildContext context, _ViewModel viewModel) {
    controller.text = viewModel.venueLocation.address ?? "";
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        try {
          FlutterPlacesDialog.getPlacesDialog().then((place) {
            focusNode.unfocus();
            viewModel.setVenueLocation(place);
            print(place);
          });
        } catch (error) {
          print(error);
        }
      }
    });

    return Padding(
      padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
      child: TextField(
        cursorColor: Colors.green,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5.0),
          icon: Image.asset("assets/locationIcon.png"),
          hintText: "Venue Location",
          errorText: viewModel.fieldValidations.isValidLocation ? null : "Please enter a location",
        ),
      ),
    );
  }

  Widget buildNextButton(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(top: 30.0, right: 20.0),
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
  PlaceDetails venueLocation;
  final Function(PlaceDetails) setVenueLocation;

  VenueFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.venueLocation,
    this.setVenueLocation,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _setVenueLocation(PlaceDetails place) {
      Venue venue = store.state.venueRegistrationState.venue;
      venue.location = place;

      store.dispatch(UpdateVenueAction(venue));
      store.dispatch(ValidateVenueLocationAction());
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToVenueAddressSceneAction());
    }

    return _ViewModel(
      venueLocation: store.state.venueRegistrationState.venue.location,
      setVenueLocation: _setVenueLocation,
      fieldValidations: store.state.venueRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.venueRegistrationState.sceneValidations.isValidVenueLocationScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
