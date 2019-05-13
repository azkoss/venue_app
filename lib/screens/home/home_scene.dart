import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/User.dart';
import 'package:venue_app/redux/actions/userRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';
import 'package:venue_app/screens/home/bookingList_scene.dart';
import 'package:venue_app/screens/home/venueProfile_scene.dart';

class HomeScene extends StatefulWidget {
  final Store<AppState> store;

  HomeScene(this.store);

  @override
  _HomeSceneState createState() => _HomeSceneState();
}

class _HomeSceneState extends State<HomeScene> with SingleTickerProviderStateMixin {
  TabController tabController;

  BookingListScene bookingListScene;
  VenueProfileScene venueProfileScene;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(vsync: this, length: 3);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    bookingListScene == null ? bookingListScene = BookingListScene(widget.store) : null;
    venueProfileScene == null ? venueProfileScene = VenueProfileScene(widget.store) : null;

    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => TabBarView(
              controller: tabController,
              children: [
                Container(color: Colors.orange),
                bookingListScene,
                venueProfileScene,
              ],
            ),
      ),
      bottomNavigationBar: buildTabBar(),
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
              icon: Image.asset(
                "assets/explore.png",
                color: tabController.index == 0 ? Colors.black : Color(0xffd4d4d4),
              ),
              text: "EXPLORE",
            ),
            Tab(
              icon: Image.asset(
                "assets/bookSelected.png",
                color: tabController.index == 1 ? Colors.black : Color(0xffd4d4d4),
              ),
              text: "BOOKINGS",
            ),
            Tab(
              icon: Image.asset(
                "assets/profileSelected.png",
                color: tabController.index == 2 ? Colors.black : Color(0xffd4d4d4),
              ),
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
  UserType userType;
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
    _setUserType(UserType userType) {
      User user = store.state.userRegistrationState.user;
      user.userType = userType;
      store.dispatch(UpdateUserAction(user));
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToTutorialSceneAction());
    }

    return _ViewModel(
      userType: store.state.userRegistrationState.user.userType,
      setUserType: _setUserType,
      fieldValidations: store.state.userRegistrationState.fieldValidations,
      canProceedToNextScene: true,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
