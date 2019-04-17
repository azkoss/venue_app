import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/redux/states/app_state.dart';

import '../../models/Venue.dart';
import '../../redux/actions/venueRegistration_actions.dart';

class VenueDetailsScene extends StatelessWidget {
  final Store<AppState> store;

  VenueDetailsScene(this.store);
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
                  buildVenueDetailsField(context, viewModel),
                  buildNextButton(context, viewModel),
                ],
              )),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Text(
        "We wish to know more about your venue.",
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

  Widget buildVenueDetailsField(BuildContext context, _ViewModel viewModel) {
    controller
      ..text = viewModel.venueDescription
      ..selection = TextSelection.collapsed(offset: controller.text.length);

    return Padding(
      padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
      child: TextField(
        cursorColor: Colors.green,
        controller: controller,
        keyboardType: TextInputType.text,
        onChanged: ((value) {
          viewModel.setVenueDescription(value);
        }),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5.0),
          icon: Image.asset("assets/description.png"),
          hintText: "Venue Description",
          counterText: "Min 10 chars",
          errorText: viewModel.fieldValidations.isValidDescription == false ? "Please enter atleast 10 chars" : null,
          fillColor: Colors.green,
        ),
      ),
    );
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
  String venueDescription;
  final Function(String) setVenueDescription;

  VenueFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.venueDescription,
    this.setVenueDescription,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _setVenueDescription(String desc) {
      Venue venue = store.state.venueRegistrationState.venue;
      venue.description = desc;

      store.dispatch(UpdateVenueAction(venue));
      store.dispatch(ValidateVenueDescriptionAction());
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToVenuePhotosSceneAction());
    }

    return _ViewModel(
      venueDescription: store.state.venueRegistrationState.venue.description,
      setVenueDescription: _setVenueDescription,
      fieldValidations: store.state.venueRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.venueRegistrationState.sceneValidations.isValidVenueDetailsScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
