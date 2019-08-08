import 'package:venue_app/repository/store_builder.dart';

class AppAuthStateCheckAction {
  final String key;
  AppAuthStateCheckAction({this.key});
}

class AppAthStateUpdateAction {
  final PersistenceModel model;
  AppAthStateUpdateAction({this.model});
}