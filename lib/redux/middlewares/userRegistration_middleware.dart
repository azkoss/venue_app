import 'package:redux/redux.dart';
import 'package:venue_app/models/User.dart';
import 'package:venue_app/redux/actions/userRegistration_actions.dart';
import 'package:venue_app/repository/app_enum_manager.dart';

import '../states/app_state.dart';

Middleware<AppState> userRegistrationMiddleware(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    //<editor-fold desc="Common User and User Field updation Actions">
    if (action is UpdateUserAction) {
      next(action);
    } else if (action is UpdateUserFieldValidationAction) {
      next(action);
    } else if (action is UpdateUserSceneValidationAction) {
      next(action);
    }
    //</editor-fold>

    //<editor-fold desc="Location Scene Actions">
    else if (action is ValidateUserLocationAction) {
      _validateUserLocation(store, action, next);
    } else if (action is ProceedToUserMobileNoSceneAction) {
      _proceedToMobileNoScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="MobileNo Scene Actions">
    else if (action is ValidateMobileNoAction) {
      _validateMobileNo(store, action, next);
    } else if (action is ProceedToOTPSceneAction) {
      _proceedToOTPScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="OTP Scene Actions">
    else if (action is ValidateOTPAction) {
      _validateOTP(store, action, next);
    } else if (action is OTPVerificationSuccessAction) {
      _validateUserOTPScene(store, action, next);
    }
//    else if (action is OTPVerificationErrorAction) {
//      _proceedToLandingScene(store, action, next);
//    }
    else if (action is ProceedToLandingSceneAction) {
      _proceedToLandingScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Landing Scene Actions">
    else if (action is ProceedToTutorialSceneAction) {
      _proceedToTutorialScene(store, action, next);
    }
    //</editor-fold>

    //<editor-fold desc="Tutorial Scene Actions">
    else if (action is ProceedToOwnerOrPlayerSceneAction) {
      _proceedToOwnerOrPlayerScene(store, action, next);
    }
    //</editor-fold>
  };
}

//<editor-fold desc="Location Scene Helper Methods">
_validateUserLocation(Store<AppState> store, ValidateUserLocationAction action, NextDispatcher next) {
  User user = store.state.userRegistrationState.user;
  UserFieldValidations validation = store.state.userRegistrationState.fieldValidations;

  bool isValid = (user.place.address.isNotEmpty) ? true : false;
  validation.updateWith(isValidPlace: isValid);

  store.dispatch(UpdateUserFieldValidationAction(validation));
  _validateUserLocationScene(store);
}

_validateUserLocationScene(Store<AppState> store) {
  User user = store.state.userRegistrationState.user;
  UserSceneValidations sceneValidation = store.state.userRegistrationState.sceneValidations;

  if (user.place.address.isNotEmpty) {
    sceneValidation.updateWith(isValidUserLocationScene: true);
    store.dispatch(UpdateUserSceneValidationAction(sceneValidation));
  }
}

_proceedToMobileNoScene(Store<AppState> store, ProceedToUserMobileNoSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("mobileNo");
}

//</editor-fold>

//<editor-fold desc="Mobile No Scene Helper Methods">
_validateMobileNo(Store<AppState> store, ValidateMobileNoAction action, NextDispatcher next) {
  User user = store.state.userRegistrationState.user;
  UserFieldValidations validation = store.state.userRegistrationState.fieldValidations;

  bool isValid = (user.mobileNo.length == 10) ? true : false;
  validation.updateWith(isValidMobileNo: isValid);

  store.dispatch(UpdateUserFieldValidationAction(validation));
  _validateUserMobileNoScene(store);
}

_validateUserMobileNoScene(Store<AppState> store) {
  User user = store.state.userRegistrationState.user;
  UserSceneValidations sceneValidation = store.state.userRegistrationState.sceneValidations;

  bool isValid = (user.mobileNo.length == 10) ? true : false;
  sceneValidation.updateWith(isValidUserMobileNoScene: isValid);
  store.dispatch(UpdateUserSceneValidationAction(sceneValidation));
}

_proceedToOTPScene(Store<AppState> store, ProceedToOTPSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("otp");
}
//</editor-fold>

//<editor-fold desc="OTP Scene Helper Methods">
_validateOTP(Store<AppState> store, ValidateOTPAction action, NextDispatcher next) {
  User user = store.state.userRegistrationState.user;
  UserFieldValidations validation = store.state.userRegistrationState.fieldValidations;

  bool isValid = (user.otp.length >= 5) ? true : false;
  validation.updateWith(isValidOTP: isValid);
  store.dispatch(UpdateUserFieldValidationAction(validation));

  if (isValid == true) {
    store.dispatch(VerifyOTPEpicAction(user.mobileNo, user.otp));
  }
}

_validateUserOTPScene(Store<AppState> store, OTPVerificationSuccessAction action, NextDispatcher next) {
  User user = store.state.userRegistrationState.user;
  UserSceneValidations sceneValidation = store.state.userRegistrationState.sceneValidations;

  bool isValid = (user.otp.length >= 5) ? true : false;
  sceneValidation.updateWith(isValidUserOTPScene: isValid);
  store.dispatch(UpdateUserSceneValidationAction(sceneValidation));
}

_proceedToLandingScene(Store<AppState> store, ProceedToLandingSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("landing");
}
//</editor-fold>

//<editor-fold desc="Landing Scene Helper Methods">
_proceedToTutorialScene(Store<AppState> store, ProceedToTutorialSceneAction action, NextDispatcher next) {
  Keys.navigationKey.currentState.pushNamed("tutorial");
}
//</editor-fold>

//<editor-fold desc="Tutorial Scene Helper Methods">
_proceedToOwnerOrPlayerScene(Store<AppState> store, ProceedToOwnerOrPlayerSceneAction action, NextDispatcher next) {
  UserType userType = store.state.userRegistrationState.user.userType;
  switch (userType) {
    case UserType.owner:
      Keys.navigationKey.currentState.pushNamed("home");
      break;
    case UserType.player:
      Keys.navigationKey.currentState.pushNamed("home");
      break;
    case UserType.none:
      // TODO: Handle this case.
      break;
  }
}
//</editor-fold>
