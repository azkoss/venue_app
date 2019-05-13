import 'package:flutter/material.dart';
import 'package:venue_app/models/Event.dart';

class EventRegistrationState {
  final Event event;
  final EventFieldValidations fieldValidations;
  final EventSceneValidations sceneValidations;

  EventRegistrationState({@required this.event, this.fieldValidations, this.sceneValidations});

  factory EventRegistrationState.initial() {
    return EventRegistrationState(
      event: Event(photos: [], startDate: DateTime.now(), endDate: DateTime.now().add(Duration(days: 1))),
      fieldValidations: EventFieldValidations(),
      sceneValidations: EventSceneValidations(),
    );
  }

  EventRegistrationState copyWith(
      {Event event, EventFieldValidations fieldValidations, EventSceneValidations sceneValidations}) {
    return EventRegistrationState(
        event: event ?? this.event,
        fieldValidations: fieldValidations ?? this.fieldValidations,
        sceneValidations: sceneValidations ?? this.sceneValidations);
  }
}
