

import 'package:flutter/material.dart';
import 'package:venue_app/repository/app_enum_manager.dart';
import 'package:venue_app/repository/store_builder.dart';

class AuthorizationState{
  final PersistenceModel authStateModel;

  AuthorizationState({ @required this.authStateModel});


  factory AuthorizationState.initial(){
    return new AuthorizationState(authStateModel: PersistenceModel(status: LoginStatus.none,type: UserType.none));
  }

  AuthorizationState copyWith({PersistenceModel authStateModel}){
    return new AuthorizationState(authStateModel: authStateModel ?? this.authStateModel);
  }

}

