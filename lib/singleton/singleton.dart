import 'package:shared_preferences/shared_preferences.dart';
import 'package:venue_app/repository/app_enum_manager.dart';
import 'package:venue_app/repository/store_builder.dart';

class Singleton {
  static final Singleton singleton = new Singleton.internal();
  factory Singleton() {
    return singleton;
  }
  Singleton.internal();

  // app login state setting and getting

  Future<void> setLoginState(PersistenceModel value, String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value.toString());
  }

  Future<LoginStatus> getLoginState(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
//  switch(preferences.getString(key)){
//    case true:
//      return LoginStatus.loggedIn;
//    case false:
//      return LoginStatus.loggedOut;
//      default:
//        return LoginStatus.none;
//  }
  }
}
