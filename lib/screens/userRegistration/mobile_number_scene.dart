import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/User.dart';
import 'package:venue_app/redux/actions/userRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

class MobileNumberScene extends StatelessWidget {
  final Store<AppState> store;

  MobileNumberScene(this.store);
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
        "What’s Your Contact Number?",
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
        "We need your number to authenticate your identity through OTP verification. We will keep your privacy as ours. Please enter your number below.",
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
      ..text = viewModel.mobileNo
      ..selection = TextSelection.collapsed(offset: controller.text.length);

    return Padding(
      padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
      child: TextField(
        cursorColor: Colors.green,
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: ((value) {
          viewModel.setMobileNo(value);
        }),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5.0),
          icon: Image.asset("assets/phoneIcon.png"),
          hintText: "Enter your mobile number",
          prefixText: controller.text.length > 0 ? "+91" : null,
          errorText:
              viewModel.fieldValidations.isValidMobileNo == false ? "Please enter a valid 10 digit mobile no" : null,
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
          onPressed: () => viewModel.canProceedToNextScene ? viewModel.proceedToNextScene() : null,
          backgroundColor: viewModel.canProceedToNextScene ? Colors.green : Colors.grey,
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}

class _ViewModel {
  String mobileNo;
  final Function(String) setMobileNo;

  UserFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.mobileNo,
    this.setMobileNo,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _setMobileNo(String mobileNo) {
      User user = store.state.userRegistrationState.user;
      user.mobileNo = mobileNo;
      store.dispatch(UpdateUserAction(user));
      store.dispatch(ValidateMobileNoAction());
    }

    _proceedToNextScene() {
      store.dispatch(RequestOTPEpicAction(store.state.userRegistrationState.user.mobileNo));
      store.dispatch(ProceedToOTPSceneAction());
    }

    return _ViewModel(
      mobileNo: store.state.userRegistrationState.user.mobileNo,
      setMobileNo: _setMobileNo,
      fieldValidations: store.state.userRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.userRegistrationState.sceneValidations.isValidUserMobileNoScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
