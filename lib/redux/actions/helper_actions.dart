import 'package:flutter/material.dart';
import 'package:venue_app/repository/store_builder.dart';

class TriggerMultipleActionsAction {
  final List actions;

  TriggerMultipleActionsAction(this.actions);
}

class AppAuthStateCheckAction {
  final VoidCallback callback;

  AppAuthStateCheckAction({this.callback});
}

class ChangeAuthStatusAction {
  final PersistenceModel statusModel;

  ChangeAuthStatusAction({this.statusModel});

}
