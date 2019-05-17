import 'package:flutter/material.dart';
import 'package:venue_app/models/VenueList.dart';
import 'package:venue_app/network/network_adapter.dart';

class VenueListState {
  final LoadingStatus loadingStatus;
  final VenueList venueList;
  final int selectedIndex;
  final int selectedFilterIndex;

  VenueListState(
      {@required this.venueList,
      this.loadingStatus = LoadingStatus.success,
      this.selectedIndex = 0,
      this.selectedFilterIndex = 0});

  factory VenueListState.initial() {
    return VenueListState(
      venueList: VenueList(venues: []),
    );
  }

  VenueListState copyWith(
      {VenueList venueList, LoadingStatus loadingStatus, int selectedIndex, int selectedFilterIndex}) {
    return VenueListState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        venueList: venueList ?? this.venueList,
        selectedIndex: selectedIndex ?? this.selectedIndex,
        selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex);
  }
}
