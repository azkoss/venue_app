import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/Venue.dart';
import 'package:venue_app/redux/actions/userRegistration_actions.dart';
import 'package:venue_app/redux/actions/venueRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

class VenueTimeAndPriceScene extends StatefulWidget {
  final Store<AppState> store;

  List<String> weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

  VenueTimeAndPriceScene(this.store);

  @override
  _VenueTimeAndPriceSceneState createState() => _VenueTimeAndPriceSceneState();
}

class _VenueTimeAndPriceSceneState extends State<VenueTimeAndPriceScene> with TickerProviderStateMixin {
  TabController groundListTabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => SafeArea(
              bottom: false,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: ListView(
                      children: <Widget>[
                        buildTitle(),
                        buildDescription(),
                        buildSubTitle1(),
                        buildSportsList(context, viewModel),
                        buildSubTitle2(),
                        buildGroundList(context, viewModel),
                        buildSubTitle3(),
                        buildWeekList(context, viewModel),
                      ],
                    ),
                  ),
                  buildLetsGoButton(context, viewModel),
                ],
              ),
            ),
      ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Text(
        "Select your available time slots and pricing",
        style: const TextStyle(
            color: const Color(0xff000000),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 33.0),
      ),
    );
  }

  Widget buildDescription() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: Text(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. sed do eiusmod tempor incididunt ut",
        style: const TextStyle(
            color: const Color(0xffc7c7c7),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 16.7),
      ),
    );
  }

  Widget buildSubTitle1() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0),
      child: Text(
        "Select your sport",
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
    Sport currentSelectedSport = viewModel.availableSports.first;
    if (viewModel.currentSelectedSport != null) {
      currentSelectedSport = viewModel.currentSelectedSport;
    }

    return DefaultTabController(
      length: viewModel.availableSports.length,
      initialIndex: viewModel.availableSports.indexOf(currentSelectedSport),
      child: Theme(
        data: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent),
        child: TabBar(
          labelStyle: TextStyle(
              fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 20.5),
          unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 20.5),
          isScrollable: true,
          labelColor: Color(0xff000000),
          unselectedLabelColor: Color(0xffdddddd),
          indicatorColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.label,
//          indicator: UnderlineTabIndicator(
//            borderSide: BorderSide(color: Colors.green, width: 2.0),
//            insets: EdgeInsets.only(bottom: 12.0),
//          ),
          tabs: sportsListTabs(viewModel),
          onTap: (index) {
            var sport = viewModel.availableSports[index];

            viewModel.setSelectedSport(sport);
            viewModel.setSelectedGround(sport.groundNames.first);
          },
        ),
      ),
    );
  }

  List<Tab> sportsListTabs(_ViewModel viewModel) {
    List<Tab> tabs = [];
    viewModel.availableSports
        .map((sport) => tabs.add(Tab(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 3.0),
                    child: Sport.displayIcon(sport.name),
                  ),
                  Text(Sport.displayName(sport.name))
                ],
              ),
            )))
        .toList();

    return tabs;
  }

  Widget buildSubTitle2() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0),
      child: Text(
        "Select your play area",
        style: const TextStyle(
            color: const Color(0xffe8e8e8),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget buildGroundList(BuildContext context, _ViewModel viewModel) {
    String currentSelectedGround = viewModel.currentSelectedSport.groundNames.first;
    if (viewModel.currentSelectedGround != null) {
      currentSelectedGround = viewModel.currentSelectedGround;
    }

    groundListTabController = TabController(
      length: viewModel.currentSelectedSport.groundNames.length,
      vsync: this,
      initialIndex: viewModel.currentSelectedSport.groundNames.indexOf(currentSelectedGround),
    );

    groundListTabController.index = viewModel.currentSelectedSport.groundNames.indexOf(currentSelectedGround);

    return Theme(
      data: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent),
      child: TabBar(
        controller: groundListTabController,
        labelStyle: TextStyle(
            fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 20.5),
        unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 20.5),
        isScrollable: true,
        labelColor: Color(0xff000000),
        unselectedLabelColor: Color(0xffdddddd),
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
          insets: EdgeInsets.only(bottom: 12.0),
        ),
        tabs: groundListTabs(viewModel),
        onTap: (index) {
          var ground = viewModel.currentSelectedSport.groundNames[index];

          viewModel.setSelectedGround(ground);
          viewModel.setSelectedDay(widget.weekDays.first);
        },
      ),
    );
  }

  List<Tab> groundListTabs(_ViewModel viewModel) {
    List<Tab> tabs = [];
    viewModel.currentSelectedSport.groundNames.map((groundName) => tabs.add(Tab(text: groundName))).toList();

    return tabs;
  }

  Widget buildSubTitle3() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0),
      child: Text(
        "Add your time slot and pricing",
        style: const TextStyle(
            color: const Color(0xffe8e8e8),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget buildWeekList(BuildContext context, _ViewModel viewModel) {
    String currentSelectedDay = widget.weekDays.first;
    if (viewModel.currentSelectedDay != null) {
      currentSelectedDay = viewModel.currentSelectedDay;
    }

    return DefaultTabController(
      length: widget.weekDays.length,
      initialIndex: widget.weekDays.indexOf(currentSelectedDay),
      child: Theme(
        data: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent),
        child: TabBar(
          labelStyle: TextStyle(
              fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 20.5),
          unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 20.5),
          isScrollable: true,
          labelColor: Color(0xff000000),
          unselectedLabelColor: Color(0xffdddddd),
          indicatorColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
            insets: EdgeInsets.only(bottom: 12.0),
          ),
          tabs: weekDayTabs(),
          onTap: (index) {
            viewModel.setSelectedDay(widget.weekDays[index]);
          },
        ),
      ),
    );
  }

  List<Tab> weekDayTabs() {
    List<Tab> tabs = [];
    widget.weekDays.map((weekDay) => tabs.add(Tab(text: weekDay))).toList();

    return tabs;
  }

  Widget buildLetsGoButton(BuildContext context, _ViewModel viewModel) {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      left: 0.0,
      child: GestureDetector(
        onTap: () => viewModel.proceedToNextScene(),
        child: Container(
          color: Colors.green,
          child: SafeArea(
            child: Container(
              height: 60.0,
              color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "LET’S GO",
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
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  List<Sport> availableSports;
  Sport currentSelectedSport;
  String currentSelectedGround;
  String currentSelectedDay;
  Function(Sport sport) setSelectedSport;
  Function(String ground) setSelectedGround;
  Function(String day) setSelectedDay;

  VenueFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.availableSports,
    this.currentSelectedSport,
    this.currentSelectedGround,
    this.currentSelectedDay,
    this.setSelectedSport,
    this.setSelectedGround,
    this.setSelectedDay,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _setSelectedSport(Sport sport) {
      Venue venue = store.state.venueRegistrationState.venue;
      venue.currentSelectedSport = sport;

      store.dispatch(UpdateVenueAction(venue));
    }

    _setSelectedGround(String ground) {
      Venue venue = store.state.venueRegistrationState.venue;
      venue.currentSelectedGround = ground;

      store.dispatch(UpdateVenueAction(venue));
    }

    _setSelectedDay(String day) {
      Venue venue = store.state.venueRegistrationState.venue;
      venue.currentSelectedDay = day;

      store.dispatch(UpdateVenueAction(venue));
    }

//    _availableGroundForSport(Sports sport) {
//      Venue venue = store.state.venueRegistrationState.venue;
//      if (venue.photos.length == 0 || index > venue.photos.length - 1) {
//        venue.photos.add(file);
//      } else {
//        venue.photos[index] = file;
//      }
//
//      store.dispatch(UpdateVenueAction(venue));
//      store.dispatch(ValidateVenuePhotosAction());
//    }

    _proceedToNextScene() {
      print("Proceed");
      store.dispatch(ProceedToOwnerOrPlayerSceneAction());
    }

    return _ViewModel(
      availableSports: store.state.venueRegistrationState.venue.sports,
      currentSelectedSport: store.state.venueRegistrationState.venue.currentSelectedSport ??
          store.state.venueRegistrationState.venue.sports.first,
      currentSelectedGround: store.state.venueRegistrationState.venue.currentSelectedGround ??
          store.state.venueRegistrationState.venue.sports.first.groundNames.first,
      currentSelectedDay: store.state.venueRegistrationState.venue.currentSelectedDay,
      setSelectedSport: _setSelectedSport,
      setSelectedGround: _setSelectedGround,
      setSelectedDay: _setSelectedDay,
      fieldValidations: store.state.venueRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.venueRegistrationState.sceneValidations.isValidVenueTimeSlotAndPriceScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
