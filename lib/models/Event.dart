import 'dart:io';

import 'package:flutter/material.dart';
import 'package:venue_app/models/Venue.dart';
import 'package:venue_app/repository/app_enum_manager.dart';



class Event {
  String name;
  String description;
  Sports sport;
  List<File> photos;
  DateTime startDate;
  DateTime endDate;
  int cost;
  int ageGroup;

  Event({
    this.name = "",
    this.description = "",
    this.sport = Sports.footBall,
    this.photos,
    this.startDate,
    this.endDate,
    this.cost,
    this.ageGroup,
  });

  static String displayNameForAgeGroup(AgeGroup group) {
    String text;
    switch (group) {
      case AgeGroup.none:
        text = "None";
        break;
      case AgeGroup.below8:
        text = "Below 8";
        break;
      case AgeGroup.between8and18:
        text = "Between 8 and 18";
        break;
      case AgeGroup.above18:
        text = "Above 18";
        break;
    }

    return text;
  }

  static Widget displayIconForAgeGroup(AgeGroup group) {
    Widget icon;
    switch (group) {
      case AgeGroup.none:
        icon = Icon(Icons.accessibility);
        break;
      case AgeGroup.below8:
        icon = Image.asset("assets/below8.png");
        break;
      case AgeGroup.between8and18:
        icon = Image.asset("assets/between8AndEghteen.png");
        break;
      case AgeGroup.above18:
        icon = Image.asset("assets/aboveEghtieen.png");
        break;
    }

    return icon;
  }
}

class EventFieldValidations {
  bool isValidName;
  bool isValidDescription;
  bool arePhotosValid;
  bool isValidStartDate;
  bool isValidEndDate;
  bool isValidCost;

  EventFieldValidations({
    this.isValidName = true,
    this.arePhotosValid = true,
    this.isValidDescription = true,
    this.isValidStartDate = true,
    this.isValidEndDate = true,
    this.isValidCost = true,
  });

  updateWith(
      {bool isValidName, bool isValidDescription, bool isValidStartDate, bool isValidEndDate, bool isValidCost}) {
    this.isValidName = isValidName ?? this.isValidName;
    this.isValidDescription = isValidDescription ?? this.isValidDescription;
    this.isValidStartDate = isValidStartDate ?? this.isValidStartDate;
    this.isValidEndDate = isValidEndDate ?? this.isValidEndDate;
    this.isValidCost = isValidCost ?? this.isValidCost;
  }
}

class EventSceneValidations {
  bool isValidEventNameScene;
  bool isValidEventDescriptionScene;
  bool isValidEventPhotosScene;
  bool isValidEventDateScene;
  bool isValidEventCostScene;

  EventSceneValidations({
    this.isValidEventNameScene = false,
    this.isValidEventDescriptionScene = false,
    this.isValidEventPhotosScene = false,
    this.isValidEventDateScene = true,
    this.isValidEventCostScene = false,
  });

  updateWith({
    bool isValidEventNameScene,
    bool isValidEventDescriptionScene,
    bool isValidEventPhotosScene,
    bool isValidEventDateScene,
    bool isValidEventCostScene,
  }) {
    this.isValidEventNameScene = isValidEventNameScene ?? this.isValidEventNameScene;
    this.isValidEventDescriptionScene = isValidEventDescriptionScene ?? this.isValidEventDescriptionScene;
    this.isValidEventPhotosScene = isValidEventPhotosScene ?? this.isValidEventPhotosScene;
    this.isValidEventDateScene = isValidEventDateScene ?? this.isValidEventDateScene;
    this.isValidEventCostScene = isValidEventCostScene ?? this.isValidEventCostScene;
  }
}
