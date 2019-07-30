import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/User.dart';
import 'package:venue_app/redux/actions/userRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

import 'package:venue_app/repository/app_enum_manager.dart';

import 'package:venue_app/screens/home/owner/bookingList_scene.dart';
import 'package:venue_app/screens/home/owner/venueProfile_scene.dart';
import 'package:venue_app/screens/home/player/playerProfile_scene.dart';
import 'package:venue_app/screens/home/player/venueList_scene.dart';

import 'explore_scene.dart';

class HomeScene extends StatefulWidget {
  final Store<AppState> store;

  HomeScene(this.store);

  @override
  _HomeSceneState createState() => _HomeSceneState();
}

class _HomeSceneState extends State<HomeScene> with SingleTickerProviderStateMixin {
  TabController tabController;

  BookingListScene bookingListScene;
  VenueListScene venueListScene;
  VenueProfileScene venueProfileScene;
  PlayerProfileScene playerProfileScene;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    bookingListScene == null ? bookingListScene = BookingListScene(widget.store) : null;
    venueListScene == null ? venueListScene = VenueListScene(widget.store) : null;
    venueProfileScene == null ? venueProfileScene = VenueProfileScene(widget.store) : null;
    playerProfileScene == null ? playerProfileScene = PlayerProfileScene(widget.store) : null;

    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => TabBarView(
              controller: tabController,
              physics: BouncingScrollPhysics(),
              children: [
                ExploreScene(widget.store),
                viewModel.userType == UserType.owner ? bookingListScene : venueListScene,
                viewModel.userType == UserType.owner ? venueProfileScene : playerProfileScene,
              ],
            ),
      ),
      bottomNavigationBar: SafeArea(child: buildTabBar()),
    );
  }

  Widget buildTabBar() {
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Color(0xffd4d4d4), width: 0.5))),
      child: Theme(
        data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
        child: TabBar(
          controller: tabController,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 10.0,
          ),
          labelColor: Colors.black,
          unselectedLabelColor: Color(0xffd4d4d4),
          indicatorSize: TabBarIndicatorSize.label,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.green, width: 3.0),
            insets: EdgeInsets.only(bottom: 8.0),
          ),
          tabs: [
            Tab(
              icon: ImageIcon(AssetImage("assets/explore.png")),
              text: "EXPLORE",
            ),
            Tab(
              icon: ImageIcon(AssetImage("assets/bookSelected.png")),
              text: "BOOKINGS",
            ),
            Tab(
              icon: ImageIcon(AssetImage("assets/profileSelected.png")),
              text: "ACCOUNT",
            ),
          ],
          onTap: (index) {
            setState(() {});
          },
        ),
      ),
    );
  }
}

class _ViewModel {
  UserType1 userType;
  final Function(UserType) setUserType;

  UserFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.userType,
    this.setUserType,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _setUserType(UserType1 userType) {
      User user = store.state.userRegistrationState.user;
      user.userType = userType;
      store.dispatch(UpdateUserAction(user));
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToTutorialSceneAction());
    }

    return _ViewModel(
      userType: store.state.userRegistrationState.user.userType,
      fieldValidations: store.state.userRegistrationState.fieldValidations,
      canProceedToNextScene: true,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
