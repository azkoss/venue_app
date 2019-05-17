import 'package:flutter/material.dart';
import 'package:flutter_places_dialog/flutter_places_dialog.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/extras/NoSplash.dart';
import 'package:venue_app/models/User.dart';
import 'package:venue_app/redux/actions/userRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

class LocationScene extends StatelessWidget {
  final Store<AppState> store;

  LocationScene(this.store);

  final TextEditingController controller = TextEditingController();
  final focusNode = NoKeyboardEditableTextFocusNode();

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
            ),
      ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Text(
        "Hi there!\nWhere are you from?",
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
        "We need your current location to load near by venues and events. Please give us access to your GPS location or you can enter manually below.",
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
    controller.text = viewModel.place.address ?? "";
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        try {
          FlutterPlacesDialog.getPlacesDialog().then((place) {
            focusNode.unfocus();
            controller.text = place.address;
            viewModel.setUserLocation(place);
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
          hintText: "Enter your location",
          errorText: viewModel.fieldValidations.isValidPlace ? null : "Please enter a location",
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
          onPressed: () => viewModel.canProceedToNextScene ? viewModel.proceedToNextScene() : null,
          backgroundColor: viewModel.canProceedToNextScene ? Colors.green : Colors.grey,
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}

class _ViewModel {
  PlaceDetails place;
  final Function(PlaceDetails) setUserLocation;

  UserFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.place,
    this.setUserLocation,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _setUserLocation(PlaceDetails place) {
      User user = store.state.userRegistrationState.user;
      user.place = place;

      store.dispatch(UpdateUserAction(user));
      store.dispatch(ValidateUserLocationAction());
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToUserMobileNoSceneAction());
    }

    return _ViewModel(
      place: store.state.userRegistrationState.user.place,
      setUserLocation: _setUserLocation,
      fieldValidations: store.state.userRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.userRegistrationState.sceneValidations.isValidUserLocationScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
