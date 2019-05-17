import 'package:venue_app/models/VenueList.dart';
import 'package:venue_app/network/network_adapter.dart';

class ListVenuesAction {
  VenueList venueList;

  ListVenuesAction(this.venueList);
}

class FetchVenueListEpicAction {
  String userID;

  FetchVenueListEpicAction(this.userID);
}

class UpdateVenueListLoadingStatusAction {
  LoadingStatus loadingStatus;
  UpdateVenueListLoadingStatusAction(this.loadingStatus);
}
