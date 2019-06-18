import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_places_dialog/flutter_places_dialog.dart';

enum Amenities { parking, washroom, water, freeWifi, medicalAssistance }

enum Sports { footBall, badminton, cricket, swimming, boxing, tableTennis, basketBall }

class Sport {
  Sports name;
  List<String> groundNames;

  Sport(this.name, this.groundNames);

  @override
  bool operator ==(other) {
    // TODO: implement ==
    return other is Sport && name.index == other.name.index;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

  static String displayName(Sports sport) {
    String text;
    switch (sport) {
      case Sports.footBall:
        text = "Football";
        break;
      case Sports.badminton:
        text = "Badminton";
        break;
      case Sports.cricket:
        text = "Cricket";
        break;
      case Sports.swimming:
        text = "Swimming";
        break;
      case Sports.boxing:
        text = "Boxing";
        break;
      case Sports.tableTennis:
        text = "Table Tennis";
        break;
      case Sports.basketBall:
        text = "Basket Ball";
        break;
    }

    return text;
  }

  static Widget displayIcon(Sports sport) {
    Widget icon;
    switch (sport) {
      case Sports.footBall:
        icon = Icon(Icons.folder_open);
        break;
      case Sports.badminton:
        icon = Icon(Icons.battery_std);
        break;
      case Sports.cricket:
        icon = Icon(Icons.chevron_right);
        break;
      case Sports.swimming:
        icon = Image.asset("assets/swimming.png");
        break;
      case Sports.boxing:
        icon = Image.asset("assets/boxing.png");
        break;
      case Sports.tableTennis:
        icon = Image.asset("assets/tableTennis.png");
        break;
      case Sports.basketBall:
        icon = Image.asset("assets/basketBall.png");
        break;
    }

    return icon;
  }

  static String displayNameForAmenity(Amenities amenity) {
    String text;
    switch (amenity) {
      case Amenities.parking:
        text = "Parking";
        break;
      case Amenities.water:
        text = "Water";
        break;
      case Amenities.washroom:
        text = "Washroom";
        break;
      case Amenities.freeWifi:
        text = "Free Wifi";
        break;
      case Amenities.medicalAssistance:
        text = "Medical Assistance";
        break;
    }

    return text;
  }

  static IconData displayIconForAmenity(Amenities amenity) {
    IconData icon;
    switch (amenity) {
      case Amenities.parking:
        icon = Icons.directions_car;
        break;
      case Amenities.water:
        icon = Icons.local_drink;
        break;
      case Amenities.washroom:
        icon = Icons.accessible;
        break;
      case Amenities.freeWifi:
        icon = Icons.wifi;
        break;
      case Amenities.medicalAssistance:
        icon = Icons.enhanced_encryption;
        break;
    }

    return icon;
  }
}

class Venue {
  PlaceDetails location;
  String venueName;
  String addressLine1;
  String addressLine2;
  String description;
  List<File> photos;
  List<Amenities> amenities;
  List<Sport> sports;

  Sport currentSelectedSport;
  String currentSelectedGround;
  String currentSelectedDay;

  Venue({
    this.location,
    this.venueName = "",
    this.addressLine1 = "",
    this.addressLine2 = "",
    this.description = "",
    this.photos,
    this.amenities,
    this.sports,
    this.currentSelectedSport,
    this.currentSelectedGround,
    this.currentSelectedDay,
  });
}

class VenueFieldValidations {
  bool isValidLocation;
  bool isValidName;
  bool isValidAddressLine1;
  bool isValidDescription;
  bool arePhotosValid;
  bool areAmenitiesValid;

  VenueFieldValidations({
    this.isValidLocation = true,
    this.isValidName = true,
    this.isValidAddressLine1 = true,
    this.isValidDescription = true,
  });

  updateWith({bool isValidLocation, bool isValidName, bool isValidAddressLine1, bool isValidDescription}) {
    this.isValidLocation = isValidLocation ?? this.isValidLocation;
    this.isValidName = isValidName ?? this.isValidName;
    this.isValidAddressLine1 = isValidAddressLine1 ?? this.isValidAddressLine1;
    this.isValidLocation = isValidDescription ?? this.isValidDescription;
  }
}

class VenueSceneValidations {
  bool isValidVenueLocationScene;
  bool isValidVenueAddressScene;
  bool isValidVenueDetailsScene;
  bool isValidVenuePhotosScene;
  bool isValidVenueAmenitiesScene;
  bool isValidVenueSportsScene;
  bool isValidVenueTimeSlotAndPriceScene;

  VenueSceneValidations(
      {this.isValidVenueLocationScene = false,
      this.isValidVenueAddressScene = false,
      this.isValidVenueDetailsScene = false,
      this.isValidVenuePhotosScene = false,
      this.isValidVenueAmenitiesScene = false,
      this.isValidVenueSportsScene = false,
      this.isValidVenueTimeSlotAndPriceScene = false});

  updateWith({
    bool isValidVenueLocationScene,
    bool isValidVenueAddressScene,
    bool isValidVenueDetailsScene,
    bool isValidVenuePhotosScene,
    bool isValidVenueAmenitiesScene,
    bool isValidVenueSportsScene,
    bool isValidVenueTimeSlotAndPriceScene,
  }) {
    this.isValidVenueLocationScene = isValidVenueLocationScene ?? this.isValidVenueLocationScene;
    this.isValidVenueAddressScene = isValidVenueAddressScene ?? this.isValidVenueAddressScene;
    this.isValidVenueDetailsScene = isValidVenueDetailsScene ?? this.isValidVenueDetailsScene;
    this.isValidVenuePhotosScene = isValidVenuePhotosScene ?? this.isValidVenuePhotosScene;
    this.isValidVenueAmenitiesScene = isValidVenueAmenitiesScene ?? this.isValidVenueAmenitiesScene;
    this.isValidVenueSportsScene = isValidVenueSportsScene ?? this.isValidVenueSportsScene;
    this.isValidVenueTimeSlotAndPriceScene =
        isValidVenueTimeSlotAndPriceScene ?? this.isValidVenueTimeSlotAndPriceScene;
  }
}
