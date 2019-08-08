import 'package:venue_app/models/signin/SignInRequestParams.dart';

class SignInEpicAction {
  final SignInRequestParams requestParams;
  SignInEpicAction(this.requestParams);
}

class SignOutEpicAction {
  final String userToken;
  SignOutEpicAction(this.userToken);
}