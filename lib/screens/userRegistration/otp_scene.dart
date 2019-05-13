import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/User.dart';
import 'package:venue_app/redux/states/app_state.dart';

import '../../redux/actions/userRegistration_actions.dart';

class OTPScene extends StatelessWidget {
  final Store<AppState> store;

  final TextEditingController controller = TextEditingController();

  OTPScene(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.create(store),
      builder: (BuildContext context, viewModel) {
        return Scaffold(
            body: ListView(
          children: <Widget>[
            buildTitle(),
            buildDescription(),
            buildTextField(context, viewModel),
            buildNextButton(context, viewModel),
            buildHelpText(),
            buildResendButton(context, viewModel)
          ],
        ));
      },
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Text(
        "Did you get the OTP for verification?",
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
        "A OTP (One Time Passcode) has been sent to +919037033354. Please enter the OTP in the field below to verify.",
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
    controller
      ..text = viewModel.otp
      ..selection = TextSelection.collapsed(offset: controller.text.length);

    return Padding(
      padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
      child: TextField(
        cursorColor: Colors.green,
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          viewModel.setOTP(value);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5.0),
          icon: Image.asset("assets/phoneMessageIcon.png"),
          hintText: "Enter OTP",
          errorText: !viewModel.fieldValidations.isValidOTP ? "Please enter a valid OTP" : null,
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
            viewModel.proceedToNextScene();
          },
          backgroundColor: viewModel.canProceedToNextScene ? Colors.green : Colors.grey,
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }

  Widget buildHelpText() {
    return Padding(
      padding: EdgeInsets.only(top: 40.0, right: 20.0),
      child: Center(
        child: Text(
          "Didn’t receive the OTP?",
          style: const TextStyle(
              color: const Color(0xffafafaf),
              fontWeight: FontWeight.w700,
              fontFamily: "GoogleSans",
              fontStyle: FontStyle.normal,
              fontSize: 17.0),
        ),
      ),
    );
  }

  Widget buildResendButton(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 20.0),
      child: FlatButton(
        child: new Text(
          "Resend CODE",
          style: const TextStyle(
              color: const Color(0xff626060),
              fontWeight: FontWeight.w700,
              fontFamily: "GoogleSans",
              fontStyle: FontStyle.normal,
              fontSize: 17.0),
        ),
        onPressed: () {
//          viewModel.proceedToNextScene();
        },
      ),
    );
  }
}

class _ViewModel {
  String otp;
  final Function(String) setOTP;

  UserFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.otp,
    this.setOTP,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _setOTP(String otp) {
      User user = store.state.userRegistrationState.user;
      user.otp = otp;
      store.dispatch(UpdateUserAction(user));
      store.dispatch(ValidateOTPAction());
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToLandingSceneAction());
    }

    return _ViewModel(
      otp: store.state.userRegistrationState.user.otp,
      setOTP: _setOTP,
      fieldValidations: store.state.userRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.userRegistrationState.sceneValidations.isValidUserOTPScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
