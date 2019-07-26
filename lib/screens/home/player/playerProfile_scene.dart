import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:venue_app/extras/custom_flexible_space_bar.dart';
import 'package:venue_app/models/Event.dart';
import 'package:venue_app/redux/actions/eventRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

class PlayerProfileScene extends StatefulWidget {
  final Store<AppState> store;

  PlayerProfileScene(this.store);

  @override
  _PlayerProfileSceneState createState() => _PlayerProfileSceneState();
}

class _PlayerProfileSceneState extends State<PlayerProfileScene> with TickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();

  final focusNode = FocusNode();

  TabController bookingListTabController;
  int selectedBookingIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => SafeArea(
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
            elevation: 3.0,
            backgroundColor: Colors.white,
            expandedHeight: 75.0,
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
      body: ListView(
        padding: EdgeInsets.only(top: 20.0),
        children: <Widget>[
          buildPhotosAndDetailsRow(),
          buildUpcomingPreviousTabs(context, viewModel),
          buildBookingTabs(context, viewModel)
        ],
      ),
    );
  }

  Widget buildHeaderNameAndLocation() {
    controller.text = "Kevin Richarden";

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
              GestureDetector(child: Image.asset("assets/edit.png"), onTap: () {}),
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

  Widget buildPhotosAndDetailsRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildProfilePhoto(),
          buildDetailsColumn(),
        ],
      ),
    );
  }

  Widget buildProfilePhoto() {
    return Container(
      height: 160,
      width: 150,
      child: Image.asset("assets/FakeDP.jpeg", fit: BoxFit.cover),
    );
  }

  Widget buildDetailsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
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
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            "100 Perks",
            style: const TextStyle(
                color: const Color(0xff797b87),
                fontWeight: FontWeight.w500,
                fontFamily: "GoogleSans",
                fontStyle: FontStyle.normal,
                fontSize: 16.7),
          ),
        ),
        ButtonTheme(
          minWidth: 0.0,
          padding: EdgeInsets.all(2.0),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                child: new Text(
                  "ADD PERKS",
                  style: const TextStyle(
                      color: const Color(0xff31b536),
                      fontWeight: FontWeight.w700,
                      fontFamily: "GoogleSans",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.help_outline, color: Colors.grey),
                splashColor: Colors.transparent,
                onPressed: () {},
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildUpcomingPreviousTabs(BuildContext context, _ViewModel viewModel) {
//    Sport currentSelectedSport = viewModel.availableSports.first;
//    if (viewModel.currentSelectedSport != null) {
//      currentSelectedSport = viewModel.currentSelectedSport;
//    }

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Theme(
          data: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent),
          child: TabBar(
            labelPadding: EdgeInsets.only(right: 20.0),
            labelStyle: TextStyle(
                fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 20.5),
            unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 20.5),
            isScrollable: true,
            labelColor: Color(0xff000000),
            unselectedLabelColor: Color(0xffdddddd),
            indicatorColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.label,
//            indicator: UnderlineTabIndicator(
//              borderSide: BorderSide(color: Colors.green, width: 2.0),
//              insets: EdgeInsets.only(bottom: 12.0),
//            ),
            tabs: [Tab(text: "Upcoming"), Tab(text: "Previous")],
            onTap: (index) {
//              viewModel.currentSelectedSport = viewModel.availableSports[index];
            },
          ),
        ),
      ),
    );
  }

  Widget buildBookingTabs(BuildContext context, _ViewModel viewModel) {
//    Sport currentSelectedSport = viewModel.availableSports.first;
//    if (viewModel.currentSelectedSport != null) {
//      currentSelectedSport = viewModel.currentSelectedSport;
//    }

    bookingListTabController = TabController(length: 3, vsync: this, initialIndex: selectedBookingIndex);
    bookingListTabController.index = selectedBookingIndex;

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20),
      child: Container(
        constraints: BoxConstraints.expand(height: 100),
        child: Theme(
          data: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent),
          child: TabBar(
            controller: bookingListTabController,
            labelPadding: EdgeInsets.only(right: 20.0),
            labelStyle: TextStyle(
                fontWeight: FontWeight.w400, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 13.3),
            unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 13.3),
            isScrollable: true,
            labelColor: Color(0xff000000),
            unselectedLabelColor: Color(0xffdddddd),
            indicatorColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.label,
//            indicator: UnderlineTabIndicator(
//              borderSide: BorderSide(color: Colors.green, width: 2.0),
//              insets: EdgeInsets.only(bottom: 12.0),
//            ),
            tabs: bookingDetailTabs(),
            onTap: (index) {
              selectedBookingIndex = index;
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  List<Widget> bookingDetailTabs() {
    return List.generate(
      3,
      (index) {
        return Container(
          width: 175,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  "Immortal Arena",
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16.7),
                ),
              ),
              Expanded(
                child: Text(
                  "Kakkanad, Kochi",
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                ),
              ),
              Expanded(
                child: Text(
                  "Ground 1, Today 6.30 to 8.30",
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                ),
              ),
              Text(
                "1000 INR",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      child: Text(
                        "Reschedule",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: selectedBookingIndex == index ? Colors.green : Color(0xffdddddd)),
                      ),
                      onTap: () {}),
                  GestureDetector(
                      child: Text("Cancel",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: selectedBookingIndex == index ? Colors.red : Color(0xffdddddd))),
                      onTap: () {}),
                ],
              ),
            ],
          ),
        );
      },
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
