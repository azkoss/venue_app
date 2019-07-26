import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/extras/custom_flexible_space_bar.dart';
import 'package:venue_app/models/Event.dart';
import 'package:venue_app/models/Venue.dart';
import 'package:venue_app/redux/actions/eventRegistration_actions.dart';
import 'package:venue_app/redux/actions/playerBooking_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

class VenueBookingScene extends StatefulWidget {
  final Store<AppState> store;

  VenueBookingScene(this.store);

  @override
  _VenueBookingSceneState createState() => _VenueBookingSceneState();
}

class _VenueBookingSceneState extends State<VenueBookingScene> with TickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();

  final focusNode = FocusNode();

  TabController groundListTabController;
  TabController dateListTabController;

  static final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day); // avoids time!
  static final lastDate = today.add(Duration(days: 14));

  DateTime selectedDate;
  var selectecTimeIndex = 3;

  var time = ["6AM", "7AM", "8AM", "9AM", "10AM", "11AM", "4PM", "5PM", "6PM", "7PM", "8PM", "9PM", "10PM", "11PM"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => SafeArea(
              bottom: false,
              child: buildAppBar(context, viewModel),
            ),
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
            expandedHeight: 75.0,
            floating: true,
            snap: true,
            pinned: true,
            flexibleSpace: CustomFlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              title: buildHeaderView(),
              titlePadding: EdgeInsets.zero,
              scaleValue: 1.0,
            ),
          ),
        ];
      },
      body: Stack(
        children: <Widget>[
          buildListView(context, viewModel),
          buildConfirmBookingButton(context, viewModel),
        ],
      ),
    );
  }

  Widget buildHeaderView() {
    controller.text = "Immortal arena";

    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
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
      top: 20.0,
      child: ListView(
        children: <Widget>[
          buildSportsSelectedSubtitle(),
          buildSportsList(context, viewModel),
          buildPlayAreaSubTitle(),
          buildPlayAreaList(context, viewModel),
          buildDatesSubTitle(),
          buildDatesList(context, viewModel),
          buildTimeSlotSubTitle(),
          buildTimeSlots(context, viewModel),
          buildTotalCashSubTitle(),
        ],
      ),
    );
  }

  Widget buildSportsSelectedSubtitle() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Text(
        "Select your Sport",
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
//    Sport currentSelectedSport = viewModel.availableSports.first;
//    if (viewModel.currentSelectedSport != null) {
//      currentSelectedSport = viewModel.currentSelectedSport;
//    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Theme(
          data: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent),
          child: TabBar(
            labelPadding: EdgeInsets.only(right: 10.0),
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
            tabs: sportsTabs(viewModel),
            onTap: (index) {
              viewModel.currentSelectedSport = viewModel.availableSports[index];
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  List<Tab> sportsTabs(_ViewModel viewModel) {
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

  Widget buildPlayAreaSubTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 20),
      child: Text(
        "Select your play area",
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

  Widget buildPlayAreaList(BuildContext context, _ViewModel viewModel) {
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Theme(
        data: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent),
        child: TabBar(
          controller: groundListTabController,
          labelPadding: EdgeInsets.only(right: 10.0),
          labelStyle: TextStyle(
              fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 20.5),
          unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 20.5),
          isScrollable: true,
          labelColor: Color(0xff000000),
          unselectedLabelColor: Color(0xffdddddd),
          indicatorColor: Colors.transparent,
//        indicatorSize: TabBarIndicatorSize.label,
//        indicator: UnderlineTabIndicator(
//          borderSide: BorderSide(color: Colors.green, width: 1),
//          insets: EdgeInsets.only(bottom: 12.0, left: 3.0, right: 3.0),
//        ),
          tabs: playAreaTabs(viewModel),
          onTap: (index) {
            viewModel.currentSelectedGround = viewModel.currentSelectedSport.groundNames[index];
            setState(() {});
          },
        ),
      ),
    );
  }

  List<Tab> playAreaTabs(_ViewModel viewModel) {
    List<Tab> tabs = [];
    viewModel.currentSelectedSport.groundNames.map((groundName) => tabs.add(Tab(text: groundName))).toList();

    return tabs;
  }

  Widget buildDatesSubTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 20),
      child: Text(
        "Select your Date",
        style: const TextStyle(
            color: const Color(0xffe8e8e8),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget buildDatesList(BuildContext context, _ViewModel viewModel) {
    dateListTabController = TabController(length: dateList().length, vsync: this);
    selectedDate = selectedDate ?? dateList().first;
    dateListTabController.index = dateList().indexOf(selectedDate);

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Theme(
        data: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent),
        child: TabBar(
          controller: dateListTabController,
          labelPadding: EdgeInsets.only(top: 10.0),
          labelStyle: TextStyle(fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal),
          unselectedLabelStyle:
              TextStyle(fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal),
          isScrollable: true,
          labelColor: Color(0xff000000),
          unselectedLabelColor: Color(0xffdddddd),
          indicatorColor: Colors.transparent,
//            indicatorSize: TabBarIndicatorSize.label,
//          indicator: UnderlineTabIndicator(
//            borderSide: BorderSide(color: Colors.green, width: 2.0),
//            insets: EdgeInsets.only(bottom: 12.0),
//          ),
          tabs: dateTabs(),
          onTap: (index) {
            selectedDate = dateList()[index];
            setState(() {});
          },
        ),
      ),
    );
  }

  List<Widget> dateTabs() {
    List<Widget> tabs = [];
    List.generate(dateList().length, (index) {
      DateTime date = dateList()[index];

      var tab = Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0), bottom: Radius.circular(25.0)),
          side: BorderSide(width: 1, color: selectedDate == date ? Color(0xff000000) : Color(0xffe8e8e8)),
        ),
        child: Container(
          height: 105,
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                child: Text(
                  DateFormat("EEEE").format(dateList()[index]).toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: "GoogleSans",
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: selectedDate == date ? Color(0xff000000) : Color(0xffe8e8e8)),
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                child: Text(
                  dateList()[index].day.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: "GoogleSans",
                      fontStyle: FontStyle.normal,
                      fontSize: 36,
                      color: selectedDate == date ? Color(0xff000000) : Color(0xffe8e8e8)),
                ),
              ),
              Flexible(
                child: Text(
                  DateFormat("MMM").format(dateList()[index]).toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: "GoogleSans",
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: selectedDate == date ? Color(0xff000000) : Color(0xffe8e8e8)),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 30.0,
                height: 2.0,
                color: selectedDate == date ? Colors.green : Colors.transparent,
              )
            ],
          ),
        ),
      );

      tabs.add(tab);
    });

    return tabs;
  }

  List<DateTime> dateList() {
    return List.generate(13, (index) => today.add(Duration(days: index)));
  }

  Widget buildTimeSlotSubTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 20.0),
      child: Text(
        "Select your time slot",
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

  Widget buildTimeSlots(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
//                      decoration: BoxDecoration(color: Colors.deepOrange),
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Image.asset(
                  "assets/pointer.png",
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.green),
              height: 3.0,
              margin: EdgeInsets.only(left: 15.0, right: 15.0),
            ),
            Container(
              height: 80,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.20, initialPage: selectecTimeIndex),
                onPageChanged: (selectedIndex) {
                  setState(() {
                    selectecTimeIndex = selectedIndex;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: selectecTimeIndex == index ? Color(0xff000000) : Colors.black54,
                              fontWeight: selectecTimeIndex == index ? FontWeight.w900 : FontWeight.w500,
                              fontFamily: "GoogleSans",
                              fontStyle: FontStyle.normal,
                              fontSize: 15.0),
                        ),
                        Text(
                          '10.00',
                          style: TextStyle(
                              color: selectecTimeIndex == index ? Color(0xff000000) : Colors.black54,
                              fontWeight: selectecTimeIndex == index ? FontWeight.w900 : FontWeight.w500,
                              fontFamily: "GoogleSans",
                              fontStyle: FontStyle.normal,
                              fontSize: 15.0),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTotalCashSubTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 20, bottom: 30),
      child: Text(
        "Total: 2000 INR",
        overflow: TextOverflow.fade,
        style: const TextStyle(
            color: const Color(0xff000000),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget buildConfirmBookingButton(BuildContext context, _ViewModel viewModel) {
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
                    "CONFIRM BOOKING",
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
  List availableSports;
  Sport currentSelectedSport;
  String currentSelectedGround;

  final Function(String) setEventDescription;

  EventFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.availableSports,
    this.currentSelectedSport,
    this.currentSelectedGround,
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
      store.dispatch(ProceedToVenueSummarySceneAction());
    }

    return _ViewModel(
      availableSports: [
        Sport(Sports.footBall, ["Ground 1", "Ground 2", "Ground3"]),
        Sport(Sports.cricket, ["Ground 1", "Ground 2"]),
        Sport(Sports.badminton, ["Ground 1"])
      ],
      currentSelectedSport: Sport(Sports.footBall, ["Ground 1", "Ground 2", "Ground3"]),
      currentSelectedGround: "Ground 1",
      setEventDescription: _setEventDescription,
      fieldValidations: store.state.eventRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.eventRegistrationState.sceneValidations.isValidEventDescriptionScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
