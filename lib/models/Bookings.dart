// To parse this JSON data, do
//
//     final ownerBookings = ownerBookingsFromJson(jsonString);

import 'dart:convert';

class OwnerBookings {
  List<MatchBooking> matchBookings;

  OwnerBookings({
    this.matchBookings,
  });

  factory OwnerBookings.fromRawJson(String str) => OwnerBookings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OwnerBookings.fromJson(Map<String, dynamic> json) => new OwnerBookings(
        matchBookings: new List<MatchBooking>.from(json["matchBookings"].map((x) => MatchBooking.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "matchBookings": new List<dynamic>.from(matchBookings.map((x) => x.toJson())),
      };
}

class MatchBooking {
  String id;
  String name;
  String image;
  String location;
  String date;
  String groundName;
  String amount;
  String rating;

  MatchBooking({
    this.id,
    this.name,
    this.image,
    this.location,
    this.date,
    this.groundName,
    this.amount,
    this.rating,
  });

  factory MatchBooking.fromRawJson(String str) => MatchBooking.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MatchBooking.fromJson(Map<String, dynamic> json) => new MatchBooking(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        location: json["location"],
        date: json["date"],
        groundName: json["groundName"],
        amount: json["amount"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "location": location,
        "date": date,
        "groundName": groundName,
        "amount": amount,
        "rating": rating,
      };
}
