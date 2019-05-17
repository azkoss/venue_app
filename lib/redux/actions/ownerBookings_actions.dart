import 'package:venue_app/models/Bookings.dart';
import 'package:venue_app/network/network_adapter.dart';

class FetchOwnerBookingsEpicAction {
  String userID;

  FetchOwnerBookingsEpicAction(this.userID);
}

class ListOwnerBookingsAction {
  OwnerBookings ownerBookings;
  ListOwnerBookingsAction(this.ownerBookings);
}

class UpdateOwnerBookingLoadingStatusAction {
  LoadingStatus loadingStatus;
  UpdateOwnerBookingLoadingStatusAction(this.loadingStatus);
}

class SetSelectedIndexForMatchesOrEvents {
  int index;
  SetSelectedIndexForMatchesOrEvents(this.index);
}

class SetSelectedFilterIndex {
  int index;
  SetSelectedFilterIndex(this.index);
}
