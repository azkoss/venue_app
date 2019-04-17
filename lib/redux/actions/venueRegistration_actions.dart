import '../../models/Venue.dart';

//<editor-fold desc="Common Venue Updation Actions">
class UpdateVenueAction {
  final Venue venue;
  UpdateVenueAction(this.venue);
}

class UpdateVenueFieldValidationAction {
  final VenueFieldValidations validations;
  UpdateVenueFieldValidationAction(this.validations);
}

class UpdateVenueSceneValidationAction {
  final VenueSceneValidations sceneValidations;
  UpdateVenueSceneValidationAction(this.sceneValidations);
}
//</editor-fold>

//<editor-fold desc="Venue Location Actions">
class ValidateVenueLocationAction {}

class ProceedToVenueAddressSceneAction {
  ProceedToVenueAddressSceneAction();
}
//</editor-fold>

//<editor-fold desc="Venue Address Scene Actions">
class ValidateVenueNameAction {}

class ValidateVenueAddressLine1Action {}

class ProceedToVenueDetailsSceneAction {
  ProceedToVenueDetailsSceneAction();
}
//</editor-fold>

//<editor-fold desc="Venue Description Scene Actions">
class ValidateVenueDescriptionAction {}

class ProceedToVenuePhotosSceneAction {
  ProceedToVenuePhotosSceneAction();
}
//</editor-fold>

////<editor-fold desc="Venue Photos Scene Actions">
class ValidateVenuePhotosAction {}

class ProceedToVenueAmenitiesSceneAction {
  ProceedToVenueAmenitiesSceneAction();
}
////</editor-fold>

////<editor-fold desc="Venue Amenities Scene Actions">
class ValidateVenueAmenitiesAction {}

class ProceedToVenueSportsSceneAction {
  ProceedToVenueSportsSceneAction();
}
////</editor-fold>

////<editor-fold desc="Venue Sports Scene Actions">
class ValidateVenueSportsAction {}

class ProceedToVenueTimeSlotSceneAction {
  ProceedToVenueTimeSlotSceneAction();
}
////</editor-fold>
