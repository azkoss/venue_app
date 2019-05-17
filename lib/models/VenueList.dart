// To parse this JSON data, do
//
//     final venueList = venueListFromJson(jsonString);

import 'dart:convert';

class VenueList {
  List<Venue> venues;

  VenueList({
    this.venues,
  });

  factory VenueList.fromRawJson(String str) => VenueList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VenueList.fromJson(Map<String, dynamic> json) => new VenueList(
        venues: new List<Venue>.from(json["venues"].map((x) => Venue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "venues": new List<dynamic>.from(venues.map((x) => x.toJson())),
      };
}

class Venue {
  String id;
  String name;
  String description;
  String addressLine1;
  String addressLine2;
  String location;
  String latitude;
  String longitude;
  String rating;
  List<String> images;
  List<String> availableSports;
  List<String> amenities;

  Venue({
    this.id,
    this.name,
    this.description,
    this.addressLine1,
    this.addressLine2,
    this.location,
    this.latitude,
    this.longitude,
    this.rating,
    this.images,
    this.availableSports,
    this.amenities,
  });

  factory Venue.fromRawJson(String str) => Venue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Venue.fromJson(Map<String, dynamic> json) => new Venue(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        location: json["location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        rating: json["rating"],
        images: new List<String>.from(json["images"].map((x) => x)),
        availableSports: new List<String>.from(json["availableSports"].map((x) => x)),
        amenities: new List<String>.from(json["amenities"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "rating": rating,
        "images": new List<dynamic>.from(images.map((x) => x)),
        "availableSports": new List<dynamic>.from(availableSports.map((x) => x)),
        "amenities": new List<dynamic>.from(amenities.map((x) => x)),
      };
}
