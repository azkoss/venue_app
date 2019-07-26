// To parse this JSON data, do
//
//     final ownerBookings = ownerBookingsFromJson(jsonString);

import 'dart:convert';

class OwnerBookings {
  List<Booking> matchBookings;
  List<Booking> eventBookings;

  OwnerBookings({
    this.matchBookings,
    this.eventBookings,
  });

  factory OwnerBookings.fromRawJson(String str) => OwnerBookings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OwnerBookings.fromJson(Map<String, dynamic> json) => new OwnerBookings(
    matchBookings: new List<Booking>.from(json["matchBookings"].map((x) => Booking.fromJson(x))),
    eventBookings: new List<Booking>.from(json["eventBookings"].map((x) => Booking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "matchBookings": new List<dynamic>.from(matchBookings.map((x) => x.toJson())),
    "eventBookings": new List<dynamic>.from(eventBookings.map((x) => x.toJson())),
  };
}

class Booking {
  String id;
  String name;
  String image;
  String location;
  String date;
  String groundName;
  String amount;
  String rating;
  String status;

  Booking({
    this.id,
    this.name,
    this.image,
    this.location,
    this.date,
    this.groundName,
    this.amount,
    this.rating,
    this.status,
  });

  factory Booking.fromRawJson(String str) => Booking.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Booking.fromJson(Map<String, dynamic> json) => new Booking(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    location: json["location"],
    date: json["date"],
    groundName: json["groundName"],
    amount: json["amount"],
    rating: json["rating"],
    status: json["status"],
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
    "status": status,
  };
}
