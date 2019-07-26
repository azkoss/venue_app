import 'package:flutter/material.dart';
import 'package:venue_app/models/VenueList.dart';
import 'package:venue_app/network/network_adapter.dart';

class PlayerBookingState {
  final LoadingStatus loadingStatus;
  final VenueList venueList;
  final int selectedIndex;
  final int selectedFilterIndex;

  PlayerBookingState(
      {@required this.venueList,
      this.loadingStatus = LoadingStatus.success,
      this.selectedIndex = 0,
      this.selectedFilterIndex = 0});

  factory PlayerBookingState.initial() {
    return PlayerBookingState(
      venueList: VenueList(venues: []),
    );
  }

  PlayerBookingState copyWith(
      {VenueList venueList, LoadingStatus loadingStatus, int selectedIndex, int selectedFilterIndex}) {
    return PlayerBookingState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        venueList: venueList ?? this.venueList,
        selectedIndex: selectedIndex ?? this.selectedIndex,
        selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex);
  }
}
