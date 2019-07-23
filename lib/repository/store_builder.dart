import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:venue_app/redux/actions/helper_actions.dart';
import 'package:venue_app/redux/selector/selectors.dart';
import 'package:venue_app/redux/states/app_state.dart';

import 'app_enum_manager.dart';

class AppStoreBuilder extends StatelessWidget {
  final Function(BuildContext context, PersistenceModel) builder;
  AppStoreBuilder({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PersistenceModel>(
      distinct: true,
      onInit: (store) {
        store.dispatch(AppAuthStateCheckAction());
      },
      converter: (Store<AppState> store) => appAuthorizationValue(store),
      builder: builder,
    );
  }
}

class PersistenceModel {
  final LoginStatus status;
  final UserType type;
  PersistenceModel({this.status, this.type});

  factory PersistenceModel.fromRawJson(String str) =>
      PersistenceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersistenceModel.fromJson(Map<String, dynamic> json) =>
      new PersistenceModel(
        status: json["LoginStatus"],
        type: json["UserType"],
      );

  Map<String, dynamic> toJson() => {
        "LoginStatus": status,
        "UserType": type,
      };
}
