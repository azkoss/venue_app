import 'package:venue_app/models/User.dart';
import 'package:venue_app/models/get%20otp/getOtpR.dart';
import 'package:venue_app/models/registration/SignUpRequestParams.dart';
import 'package:venue_app/models/signin/SignInRequestParams.dart';

//<editor-fold desc="Update User Actions">
class UpdateUserAction {
  final User user;
  UpdateUserAction(this.user);
}
//</editor-fold>

//<editor-fold desc="Update User Filed Validation Actions">
class UpdateUserFieldValidationAction {
  final UserFieldValidations fieldValidations;
  UpdateUserFieldValidationAction(this.fieldValidations);
}
//</editor-fold>

//<editor-fold desc="Update User-Scene Validation Action">
class UpdateUserSceneValidationAction {
  final UserSceneValidations sceneValidations;
  UpdateUserSceneValidationAction(this.sceneValidations);
}
//</editor-fold>

//<editor-fold desc="Validate User Locations Actions">
class ValidateUserLocationAction {
  ValidateUserLocationAction();
}
//</editor-fold>

//<editor-fold desc="Proceed to User Mobile No Scene Action">
class ProceedToUserMobileNoSceneAction {
  ProceedToUserMobileNoSceneAction();
}
//</editor-fold>

//<editor-fold desc="Mobile Scene Actions">
class ValidateMobileNoAction {
  ValidateMobileNoAction();
}
//</editor-fold>

//<editor-fold desc="Request OTP Epic Action">
class RequestOTPEpicAction {
  final GetOtpRequest request;
  RequestOTPEpicAction(this.request);
}
//</editor-fold>

//<editor-fold desc="Proceed to Otp Scene Action">
class ProceedToOTPSceneAction {
  ProceedToOTPSceneAction();
}
//</editor-fold>

class GetOtpDataAction {

 final GetOTPResponseModel model;
  GetOtpDataAction(this.model);

}

//<editor-fold desc="OTP Scene Actions">
class ValidateOTPAction {
  ValidateOTPAction();
}
//</editor-fold>

//<editor-fold desc="Verify OTP Action">
class VerifyOTPEpicAction {
  VerifyOTPEpicAction();
}
//</editor-fold>

//<editor-fold desc="OTP Verifications Success Action">
class OTPVerificationSuccessAction {
  final String accessToken;

  OTPVerificationSuccessAction(this.accessToken);
}
//</editor-fold>

//<editor-fold desc="Landing Scene Actions">
class ProceedToLandingSceneAction {
  ProceedToLandingSceneAction();
}
//</editor-fold>


//<editor-fold desc="Proceed to Venue Location Actions">
class ProceedToVenueLocationSceneAction {
  ProceedToVenueLocationSceneAction();
}
//</editor-fold>

//<editor-fold desc="Complete User Registration Actions">
class CompleteUserRegistrationsEpicAction {
  final SignUpRequestParams requestParams;
  final Function onSuccessCallback;
  CompleteUserRegistrationsEpicAction(
      this.requestParams,
      this.onSuccessCallback,);
}
//</editor-fold>

//<editor-fold desc="Tutorial Page Actions">

class ProceedToTutorialSceneAction {
  ProceedToTutorialSceneAction();
}
//</editor-fold>

//<editor-fold desc="Proceed to Owner or Player Scene Action">
class ProceedToOwnerOrPlayerSceneAction {
  ProceedToOwnerOrPlayerSceneAction();
}
//</editor-fold>

