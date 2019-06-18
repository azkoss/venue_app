import 'package:venue_app/models/VenueList.dart';
import 'package:venue_app/network/network_adapter.dart';

//region Venue List Scene Actions
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

class ProceedToVenueInfoSceneAction {}

class ProceedToVenueBookingSceneAction {}

class ProceedToVenueSummarySceneAction {}

class ProceedToVenueListMapSceneAction {}
//endregion
