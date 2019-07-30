import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/User.dart';
import 'package:venue_app/models/registration/SignUpRequestParams.dart';

import 'package:venue_app/redux/actions/userRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

import '../../repository/app_enum_manager.dart';

class LandingScene extends StatelessWidget {
  final Store<AppState> store;

  LandingScene(this.store);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => SafeArea(
              child: ListView(
                children: <Widget>[
                  buildTitle(),
                  buildDescription(),
                  buildRadioButton1(context, viewModel),
                  buildSubDescription1(),
                  buildRadioButton2(context, viewModel),
                  buildSubDescription2(),
                  buildNextButton(context, viewModel),
                ],
              ),
            ),
      ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: new Text(
        "Do you have a venue to register with us?",
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
      child: new Text(
        "You can register your venue with us or you can choose a venue to play. There are two types of "
        "login available, ie. as a host or a player.",
        style: const TextStyle(
            color: const Color(0xffc7c7c7),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 17.3),
      ),
    );
  }

  Widget buildRadioButton1(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 5.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio(
            activeColor: Colors.green,
            value: UserType1.owner,
            groupValue: viewModel.userType,
            onChanged: (value) {
              viewModel.setUserType(UserType1.owner);
              print("player clicked");
            },
          ),
          Text(
            "Yes, I own a sports venue",
            style: const TextStyle(
                color: const Color(0xff1f1f1f),
                fontWeight: FontWeight.w700,
                fontFamily: "GoogleSans",
                fontStyle: FontStyle.normal,
                fontSize: 18.7),
          ),
        ],
      ),
    );
  }

  Widget buildSubDescription1() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: new Text(
        "Once you register the venue, you will get booking requests from other users and make more revenue from your venue and easily manage your business.",
        style: const TextStyle(
            color: const Color(0xffc7c7c7),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 16.8),
      ),
    );
  }

  Widget buildRadioButton2(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 5.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio(
            activeColor: Colors.green,
            value: UserType1.player,
            groupValue: viewModel.userType,
            onChanged: (value) {
              viewModel.setUserType(UserType1.player);
              print("player clicked");
            },
          ),
          Text(
            "No, I’m here to play",
            style: const TextStyle(
                color: const Color(0xff1f1f1f),
                fontWeight: FontWeight.w700,
                fontFamily: "GoogleSans",
                fontStyle: FontStyle.normal,
                fontSize: 18.7),
          ),
        ],
      ),
    );
  }

  Widget buildSubDescription2() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: new Text(
        "You can choose a venue around your location, book your slot early and enjoyyour sport. No booking charges needed.",
        style: const TextStyle(
            color: const Color(0xffc7c7c7),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 17.3),
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
            viewModel.proceedToNextScene(viewModel.userType);
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}

class _ViewModel {
  UserType1 userType;
  final Function(UserType1) setUserType;

  UserFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function(UserType1) proceedToNextScene;


  _ViewModel({
    this.userType,
    this.setUserType,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {


    _setUserType(UserType1 userType) {
      User user = store.state.userRegistrationState.user;
      user.userType = userType;
      store.dispatch(UpdateUserAction(user));
    }



    _proceedToNextScene(UserType userType) {
      if (userType == UserType.owner) {
        store.dispatch(ProceedToVenueLocationSceneAction());
      } else {
        store.dispatch(ProceedToTutorialSceneAction());
      }
    }

    void onSignUpSuccess(){
      store.dispatch(ProceedToTutorialSceneAction());

    }

    proceedToNextScene(UserType1 userType) {
      if (userType == UserType1.owner) {
        store.dispatch(ProceedToVenueLocationSceneAction());
      } else {
        User user = store.state.userRegistrationState.user;
        SignUpRequestParams params = SignUpRequestParams(
            firstName: "John",
            lastName: "Doe",
            description: "Nothing",
            email: "john@gmail.com",
            latitude: 0.0,
            location: "yyhy",
            phone: "+91 9539394292",
            role: 1 ,
            longitude: 0.0
        );
        store.dispatch(CompleteUserRegistrationsEpicAction(params, onSignUpSuccess));
        //store.dispatch(ProceedToTutorialSceneAction());
      }
    }

    return _ViewModel(
      userType: store.state.userRegistrationState.user.userType,
      setUserType: _setUserType,
      fieldValidations: store.state.userRegistrationState.fieldValidations,
      canProceedToNextScene: true,
      proceedToNextScene: proceedToNextScene,
    );
  }
}
