import 'package:flutter/material.dart';
import 'package:venue_app/models/Bookings.dart';
import 'package:venue_app/network/network_adapter.dart';

class OwnerBookingsState {
  final LoadingStatus loadingStatus;
  final OwnerBookings bookings;
  final int selectedIndex;
  final int selectedFilterIndex;

  OwnerBookingsState(
      {@required this.bookings,
      this.loadingStatus = LoadingStatus.success,
      this.selectedIndex = 0,
      this.selectedFilterIndex = 0});

  factory OwnerBookingsState.initial() {
    return OwnerBookingsState(
      bookings: OwnerBookings(matchBookings: []),
    );
  }

  OwnerBookingsState copyWith(
      {OwnerBookings bookings, LoadingStatus loadingStatus, int selectedIndex, int selectedFilterIndex}) {
    return OwnerBookingsState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        bookings: bookings ?? this.bookings,
        selectedIndex: selectedIndex ?? this.selectedIndex,
        selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex);
  }
}
