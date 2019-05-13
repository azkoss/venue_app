import 'package:flutter/material.dart';
import 'package:venue_app/models/Bookings.dart';
import 'package:venue_app/network/network_adapter.dart';

class OwnerBookingsState {
  final LoadingStatus loadingStatus;
  final OwnerBookings bookings;

  OwnerBookingsState({@required this.bookings, this.loadingStatus = LoadingStatus.success});

  factory OwnerBookingsState.initial() {
    return OwnerBookingsState(
      loadingStatus: LoadingStatus.success,
      bookings: OwnerBookings(matchBookings: []),
    );
  }

  OwnerBookingsState copyWith({OwnerBookings bookings, LoadingStatus loadingStatus}) {
    return OwnerBookingsState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      bookings: bookings ?? this.bookings,
    );
  }
}
