import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/Venue.dart';
import 'package:venue_app/redux/actions/venueRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';


class VenueAddressScene extends StatelessWidget {
  final Store<AppState> store;

  VenueAddressScene(this.store);
  final TextEditingController venueNameController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
          converter: (store) => _ViewModel.create(store),
          builder: (BuildContext context, _ViewModel viewModel) => ListView(
                children: <Widget>[
                  buildTitle(),
                  buildDescription(),
                  buildNameField(context, viewModel),
                  buildAddressField1(context, viewModel),
                  buildAddressField2(context, viewModel),
                  buildNextButton(context, viewModel),
                ],
              )),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Text(
        "What is the name and address of the venue?",
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

  Widget buildNameField(BuildContext context, _ViewModel viewModel) {
    venueNameController
      ..text = viewModel.venueName
      ..selection = TextSelection.collapsed(offset: venueNameController.text.length);

    return Padding(
      padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
      child: TextField(
        cursorColor: Colors.green,
        controller: venueNameController,
        keyboardType: TextInputType.text,
        onChanged: (value) => viewModel.setVenueName(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5.0),
          icon: Image.asset("assets/ground.png"),
          hintText: "Venue Name",
          errorText: viewModel.fieldValidations.isValidName ? null : "Min 4 characters",
          fillColor: Colors.green,
        ),
      ),
    );
  }

  Widget buildAddressField1(BuildContext context, _ViewModel viewModel) {
    addressLine1Controller
      ..text = viewModel.addressLine1
      ..selection = TextSelection.collapsed(offset: addressLine1Controller.text.length);

    return Padding(
      padding: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
      child: TextField(
        cursorColor: Colors.green,
        controller: addressLine1Controller,
        keyboardType: TextInputType.text,
        onChanged: (value) => viewModel.setAddressLine1(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5.0),
          icon: Image.asset("assets/house.png"),
          hintText: "Address line 1",
          errorText: viewModel.fieldValidations.isValidAddressLine1 ? null : "Min 4 characters",
          fillColor: Colors.green,
        ),
      ),
    );
  }

  Widget buildAddressField2(BuildContext context, _ViewModel viewModel) {
    addressLine2Controller
      ..text = viewModel.addressLine2
      ..selection = TextSelection.collapsed(offset: addressLine2Controller.text.length);

    return Padding(
      padding: EdgeInsets.only(top: 25.0, left: 55.0, right: 20.0),
      child: TextField(
        cursorColor: Colors.green,
        controller: addressLine2Controller,
        keyboardType: TextInputType.text,
        onChanged: (value) => viewModel.setAddressLine2(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5.0),
          hintText: "Address line 2 (Optional)",
          fillColor: Colors.green,
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
  String venueName;
  String addressLine1;
  String addressLine2;
  final Function(String) setVenueName;
  final Function(String) setAddressLine1;
  final Function(String) setAddressLine2;

  VenueFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.venueName,
    this.addressLine1,
    this.addressLine2,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.setVenueName,
    this.setAddressLine1,
    this.setAddressLine2,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _setVenueName(String venueName) {
      Venue venue = store.state.venueRegistrationState.venue;
      venue.venueName = venueName;

      store.dispatch(UpdateVenueAction(venue));
      store.dispatch(ValidateVenueNameAction());
    }

    _setAddressLine1(String addressLine1) {
      Venue venue = store.state.venueRegistrationState.venue;
      venue.addressLine1 = addressLine1;

      store.dispatch(UpdateVenueAction(venue));
      store.dispatch(ValidateVenueAddressLine1Action());
    }

    _setAddressLine2(String addressLine2) {
      Venue venue = store.state.venueRegistrationState.venue;
      venue.addressLine2 = addressLine2;

      store.dispatch(UpdateVenueAction(venue));
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToVenueDetailsSceneAction());
    }

    return _ViewModel(
      venueName: store.state.venueRegistrationState.venue.venueName,
      addressLine1: store.state.venueRegistrationState.venue.addressLine1,
      addressLine2: store.state.venueRegistrationState.venue.addressLine2,
      setVenueName: _setVenueName,
      setAddressLine1: _setAddressLine1,
      setAddressLine2: _setAddressLine2,
      fieldValidations: store.state.venueRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.venueRegistrationState.sceneValidations.isValidVenueAddressScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
