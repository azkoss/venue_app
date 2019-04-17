import 'dart:io';

import 'package:flutter_places_dialog/flutter_places_dialog.dart';

enum Amenities {
  parking,
  washroom,
  water,
  freeWifi,
  medicalAssistance,
}

enum Sports {
  footBall,
  badminton,
  cricket,
  swimming,
  boxing,
  tableTennis,
  basketBall,
}

class Sport {
  Sports name;
  List<String> groundNames;

  @override
  bool operator ==(other) {
    // TODO: implement ==
    return other is Sport && name.index == other.name.index;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
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

  Venue({
    this.location,
    this.venueName = "",
    this.addressLine1 = "",
    this.addressLine2 = "",
    this.description = "",
    this.photos,
    this.amenities,
    this.sports,
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

  VenueSceneValidations({
    this.isValidVenueLocationScene = false,
    this.isValidVenueAddressScene = false,
    this.isValidVenueDetailsScene = false,
    this.isValidVenuePhotosScene = false,
    this.isValidVenueAmenitiesScene = false,
    this.isValidVenueSportsScene = false,
  });

  updateWith({
    bool isValidVenueLocationScene,
    bool isValidVenueAddressScene,
    bool isValidVenueDetailsScene,
    bool isValidVenuePhotosScene,
    bool isValidVenueAmenitiesScene,
    bool isValidVenueSportsScene,
  }) {
    this.isValidVenueLocationScene = isValidVenueLocationScene ?? this.isValidVenueLocationScene;
    this.isValidVenueAddressScene = isValidVenueAddressScene ?? this.isValidVenueAddressScene;
    this.isValidVenueDetailsScene = isValidVenueDetailsScene ?? this.isValidVenueDetailsScene;
    this.isValidVenuePhotosScene = isValidVenuePhotosScene ?? this.isValidVenuePhotosScene;
    this.isValidVenueAmenitiesScene = isValidVenueAmenitiesScene ?? this.isValidVenueAmenitiesScene;
    this.isValidVenueSportsScene = isValidVenueSportsScene ?? this.isValidVenueSportsScene;
  }
}
