import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:venue_app/extras/custom_flexible_space_bar.dart';
import 'package:venue_app/models/Event.dart';
import 'package:venue_app/models/Venue.dart';
import 'package:venue_app/redux/actions/eventRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

class VenueInfoScene extends StatelessWidget {
  final Store<AppState> store;

  VenueInfoScene(this.store);

  final TextEditingController controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => buildAppBar(context, viewModel),
      ),
    );
  }

  buildAppBar(BuildContext context, _ViewModel viewModel) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            elevation: 3.0,
            backgroundColor: Colors.white,
            expandedHeight: 80.0,
            floating: true,
            snap: true,
            pinned: true,
            flexibleSpace: CustomFlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              title: buildHeaderNameAndLocation(),
              titlePadding: EdgeInsets.zero,
              scaleValue: 1.0,
            ),
          ),
        ];
      },
      body: Stack(
        children: <Widget>[
          buildListView(context, viewModel),
          buildLetsBookButton(context, viewModel),
        ],
      ),
    );
  }

  Widget buildHeaderNameAndLocation() {
    controller.text = "Immortal arena";

    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
      child: Wrap(
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 5.0),
                        ),
                        style: TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w500,
                            fontFamily: "GoogleSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 21.5),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 15.0,
                        ),
                        Text(
                          "Kochi",
                          style: const TextStyle(
                              color: const Color(0xff797b87),
                              fontWeight: FontWeight.w400,
                              fontFamily: "GoogleSans",
                              fontStyle: FontStyle.normal,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(child: Icon(Icons.arrow_back), onTap: () => Keys.navigationKey.currentState.pop()),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Container(
              color: Colors.green,
              height: 1.0,
            ),
          )
        ],
      ),
    );
  }

  Widget buildListView(BuildContext context, _ViewModel viewModel) {
    return Positioned(
      bottom: 60.0,
      left: 0.0,
      right: 0.0,
      top: 0.0,
      child: ListView(
        children: <Widget>[
          buildPhotosAndDetailsRow(),
          buildDescription(),
          buildSportsSelectedSubtitle(),
          buildSportsList(context, viewModel),
          buildTimingsSelectedSubTitle(),
          buildTimingsList(context, viewModel),
          buildAmenitiesSubTitle(),
          buildAmenitiesList(context, viewModel),
        ],
      ),
    );
  }

  Widget buildPhotosAndDetailsRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildPhotosGrid(),
          buildDetailsColumn(),
        ],
      ),
    );
  }

  Widget buildPhotosGrid() {
    return Container(
      height: 160,
      width: 150,
      child: Column(
        children: <Widget>[
          Container(
            height: 105,
            width: 150,
            child: Image.asset("assets/FakeDP.jpeg", fit: BoxFit.cover),
          ),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10.0, right: 10.0),
                  child: Image.asset("assets/FakeDP.jpeg", fit: BoxFit.cover),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                  child: Image.asset("assets/FakeDP.jpeg", fit: BoxFit.cover),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Image.asset("assets/FakeDP.jpeg", fit: BoxFit.cover),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildDetailsColumn() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "+ 91 9986029747",
                  style: const TextStyle(
                      color: const Color(0xff797b87),
                      fontWeight: FontWeight.w400,
                      fontFamily: "GoogleSans",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.7),
                ),
                Icon(
                  Icons.phone_android,
                  color: Colors.grey,
                )
              ],
            ),
          ),
          Text(
            "Behind LP School Irumpanam Kochi, Kerala",
            softWrap: true,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: const TextStyle(
                color: const Color(0xff797b87),
                fontWeight: FontWeight.w400,
                fontFamily: "GoogleSans",
                fontStyle: FontStyle.normal,
                fontSize: 16.7),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SmoothStarRating(
              allowHalfRating: false,
              starCount: 5,
              rating: 4.0,
              size: 20.0,
              color: Colors.yellow,
              borderColor: Colors.yellow,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              "4.0 (1235)",
              style: const TextStyle(
                  color: const Color(0xff797b87),
                  fontWeight: FontWeight.w400,
                  fontFamily: "GoogleSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 16.7),
            ),
          ),
//        Padding(
//          padding: const EdgeInsets.only(top: 10.0),
//          child: Text(
//            "3500 INR/Month",
//            style: const TextStyle(
//                color: const Color(0xff797b87),
//                fontWeight: FontWeight.w500,
//                fontFamily: "GoogleSans",
//                fontStyle: FontStyle.normal,
//                fontSize: 16.7),
//          ),
//        ),
//        ButtonTheme(
//          minWidth: 0.0,
//          padding: EdgeInsets.all(2.0),
//          splashColor: Colors.transparent,
//          highlightColor: Colors.transparent,
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.end,
//            mainAxisSize: MainAxisSize.min,
//            children: <Widget>[
//              FlatButton(
//                child: new Text(
//                  "CHANGE",
//                  style: const TextStyle(
//                      color: const Color(0xff31b536),
//                      fontWeight: FontWeight.w700,
//                      fontFamily: "GoogleSans",
//                      fontStyle: FontStyle.normal,
//                      fontSize: 20.0),
//                ),
//                onPressed: () {},
//              ),
//              IconButton(
//                icon: Icon(Icons.help_outline, color: Colors.grey),
//                splashColor: Colors.transparent,
//                onPressed: () {},
//              )
//            ],
//          ),
//        ),
        ],
      ),
    );
  }

  Widget buildDescription() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: Text(
        "Lorem ipsum dolor sit amet, consectetur  da qwadipiscing elit, sed do eiusmod tempor  re incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud  asda exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        style: const TextStyle(
            color: const Color(0xffc7c7c7),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 16.7),
      ),
    );
  }

  Widget buildSportsSelectedSubtitle() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0),
      child: Text(
        "Sports Available Here",
        overflow: TextOverflow.fade,
        style: const TextStyle(
            color: const Color(0xffe8e8e8),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget buildSportsList(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: Container(
        height: 60.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: Sports.values.length,
          itemBuilder: (context, index) {
            var sport = Sports.values[index];

            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Sport.displayIcon(sport),
                  ),
                  Stack(
                    children: <Widget>[
                      Text(
                        Sport.displayName(sport),
                        style: const TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w400,
                            fontFamily: "GoogleSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 20.5),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildTimingsSelectedSubTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Text(
        "Timings",
        style: const TextStyle(
            color: const Color(0xffe8e8e8),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget buildTimingsList(BuildContext context, _ViewModel viewModel) {
    var timings = ["5:00 - 11:00", "16:00 - 23:00"];
    var icons = [Icon(Icons.wb_sunny), Icon(Icons.wb_iridescent)];

    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: Container(
        height: 60.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: timings.length,
          itemBuilder: (context, index) {
            var timing = timings[index];

            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: icons[index],
                  ),
                  Stack(
                    children: <Widget>[
                      Text(
                        timing.toString(),
                        style: TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w400,
                            fontFamily: "GoogleSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 20.5),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildAmenitiesSubTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Text(
        "Amenities Provided Here",
        overflow: TextOverflow.fade,
        style: const TextStyle(
            color: const Color(0xffe8e8e8),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget buildAmenitiesList(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: Container(
        height: 60.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: Amenities.values.length,
          itemBuilder: (context, index) {
            var amenity = Amenities.values[index];

            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Icon(Sport.displayIconForAmenity(amenity)),
                  ),
                  Stack(
                    children: <Widget>[
                      Text(
                        Sport.displayNameForAmenity(amenity),
                        style: TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w400,
                            fontFamily: "GoogleSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 20.5),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildLetsBookButton(BuildContext context, _ViewModel viewModel) {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      left: 0.0,
      child: Container(
        height: 60.0,
        color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LET’S BOOK",
              style: const TextStyle(
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w500,
                  fontFamily: "GoogleSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 23.3),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewModel {
  String eventDescription;
  final Function(String) setEventDescription;

  EventFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.eventDescription,
    this.setEventDescription,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _setEventDescription(String desc) {
      Event event = store.state.eventRegistrationState.event;
      event.description = desc;

      store.dispatch(UpdateEventAction(event));
      store.dispatch(ValidateEventDescriptionAction());
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToEventSportSceneAction());
    }

    return _ViewModel(
      eventDescription: store.state.eventRegistrationState.event.description,
      setEventDescription: _setEventDescription,
      fieldValidations: store.state.eventRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.eventRegistrationState.sceneValidations.isValidEventDescriptionScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
