import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/extras/custom_flexible_space_bar.dart';
import 'package:venue_app/models/Event.dart';
import 'package:venue_app/models/Venue.dart';
import 'package:venue_app/redux/actions/eventRegistration_actions.dart';
import 'package:venue_app/redux/actions/userRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

class VenueSummaryScene extends StatefulWidget {
  final Store<AppState> store;

  VenueSummaryScene(this.store);

  @override
  _VenueSummarySceneState createState() => _VenueSummarySceneState();
}

class _VenueSummarySceneState extends State<VenueSummaryScene> with TickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();

  final focusNode = FocusNode();

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
              title: buildHeaderView(context, viewModel),
              titlePadding: EdgeInsets.zero,
              scaleValue: 1.0,
            ),
          ),
        ];
      },
      body: buildListView(context, viewModel),
    );
  }

  Widget buildHeaderView(BuildContext context, _ViewModel viewModel) {
    controller.text = "Summary";

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
              GestureDetector(child: Icon(Icons.arrow_back), onTap: () => viewModel.proceedToNextScene()),
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
    return ListView(
      children: <Widget>[
        buildSelectedVenueTitle(),
        buildSelectedVenueAddress(),
        buildSelectedSport(),
        buildSelectedGround(),
        buildSelectedDate(),
        buildAmountDetailsAndQRCode(),
        buildRescheduleSubTitle(),
        buildReschedulePolicyDetails(),
        buildCancelSubTitle(),
        buildCancelPolicyDetails(),
        buildTermsOfServiceSubTitle(),
        buildTermsOfServiceDetails(),
      ],
    );
  }

  Widget buildSelectedVenueTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, top: 20, right: 20),
      child: new Text(
        "Immortal arena",
        style: const TextStyle(
            color: const Color(0xff000000),
            fontWeight: FontWeight.w500,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 21.5),
      ),
    );
  }

  Widget buildSelectedVenueAddress() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Behind LP School, Near Chaitram, Irumpanam, Kochi, Kerala 682309",
        style: const TextStyle(
            color: const Color(0xff797b87),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 13.3),
      ),
    );
  }

  Widget buildSelectedSport() {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Image.asset("assets/basketBall.png"),
          ),
          Expanded(
            child: new Text(
              "Football",
              style: const TextStyle(
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w700,
                  fontFamily: "GoogleSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 20.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSelectedGround() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: new Text(
        "Ground 1",
        style: const TextStyle(
            color: const Color(0xff000000),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 20.5),
      ),
    );
  }

  Widget buildSelectedDate() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: new Text(
        "8th Nov 2018, Tomorrow, 06:00",
        style: const TextStyle(
            color: const Color(0xff000000),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 16.7),
      ),
    );
  }

  Widget buildAmountDetailsAndQRCode() {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Total: 2000 INR",
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w700,
                      fontFamily: "GoogleSans",
                      fontStyle: FontStyle.normal,
                      fontSize: 24.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 5),
                  child: Text(
                    "NB: Amount should be paid after scanning qr code at the venue. You should carry a photo id card for "
                    "verification at venue.",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w500,
                        fontFamily: "GoogleSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 15.0),
                  ),
                ),
              ],
            ),
          ),
          Image.asset("assets/qrcode.png")
        ],
      ),
    );
  }

  Widget buildRescheduleSubTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Text(
        "Reschedule policy",
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

  Widget buildReschedulePolicyDetails() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20),
      child: new Text(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
        style: const TextStyle(
            color: const Color(0xffafafaf),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 11.7),
      ),
    );
  }

  Widget buildCancelSubTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 20),
      child: Text(
        "Cancel policy",
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

  Widget buildCancelPolicyDetails() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20),
      child: new Text(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
        style: const TextStyle(
            color: const Color(0xffafafaf),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 11.7),
      ),
    );
  }

  Widget buildTermsOfServiceSubTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 20),
      child: Text(
        "Terms of service",
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

  Widget buildTermsOfServiceDetails() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, bottom: 20),
      child: new Text(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
        style: const TextStyle(
            color: const Color(0xffafafaf),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 11.7),
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
      store.dispatch(ProceedToOwnerOrPlayerSceneAction());
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
