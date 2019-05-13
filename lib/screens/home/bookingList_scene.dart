import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/Bookings.dart';
import 'package:venue_app/network/network_adapter.dart';
import 'package:venue_app/redux/actions/helper_actions.dart';
import 'package:venue_app/redux/actions/ownerBookings_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';
import 'package:venue_app/screens/home/bookingList_tile.dart';

class BookingListScene extends StatefulWidget {
  final Store<AppState> store;

  BookingListScene(this.store);

  @override
  _BookingListSceneState createState() => _BookingListSceneState();
}

class _BookingListSceneState extends State<BookingListScene> {
  final TextEditingController controller = TextEditingController();

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        onInitialBuild: (viewModel) {
          if (viewModel.ownerBookings.matchBookings.length == 0) {
            viewModel.fetchOwnerBookingsList();
          }
        },
        builder: (BuildContext context, _ViewModel viewModel) {
          return ModalProgressHUD(
            child: buildAppBar(viewModel),
            color: Colors.black26,
            inAsyncCall: viewModel.loadingStatus == LoadingStatus.loading,
            progressIndicator: SpinKitWanderingCubes(
              size: 20.0,
              color: Colors.green,
            ),
          );
        },
      ),
    );
  }

  buildAppBar(_ViewModel viewModel) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            elevation: 3.0,
            backgroundColor: Colors.white,
            expandedHeight: 170.0,
            floating: true,
            pinned: true,
            snap: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              titlePadding: EdgeInsets.all(0.0),
              title: buildBookingsListFilters(),
              background: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildLocationSettingsAndSearchBar(),
                  buildMatchesEventsButtons(),
                ],
              ),
            ),
          ),
        ];
      },
      body: buildBookingsList(viewModel),
    );
  }

  Widget buildLocationSettingsAndSearchBar() {
    controller.text = "Carnival Infopark";

    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 15.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: TextField(
                    cursorColor: Colors.green,
                    controller: controller,
                    keyboardType: TextInputType.text,
                    onChanged: ((value) {}),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 8.0),
                      labelText: "Selected Location",
                    ),
                  ),
                ),
                ButtonTheme(
                  minWidth: 0.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.assessment),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1.0,
            margin: EdgeInsets.only(right: 15.0),
            color: Colors.green,
          )
        ],
      ),
    );
  }

  Widget buildMatchesEventsButtons() {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
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
          indicatorColor: Colors.green,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
            insets: EdgeInsets.only(bottom: 10.0),
          ),
          tabs: [
            Tab(text: "Matches"),
            Tab(text: "Events"),
          ],
        ),
      ),
    );
  }

  Widget buildBookingsListFilters() {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Theme(
        data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
        child: TabBar(
//        labelPadding: EdgeInsets.only(left: 10.0, right: 10.0),
          labelStyle: TextStyle(
              fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 16.8),
          unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 16.8),
          isScrollable: true,
          labelColor: Color(0xff000000),
          unselectedLabelColor: Color(0xffdddddd),
          indicatorColor: Colors.transparent,
          tabs: [
            Tab(text: "Recent"),
            Tab(text: "Accepted"),
            Tab(text: "Previous"),
          ],
          onTap: (index) {},
        ),
      ),
    );
  }

  Widget buildBookingsList(_ViewModel viewModel) {
    return RefreshIndicator(
      displacement: 30.0,
      color: Colors.green,
      onRefresh: () {
        return Future.delayed(Duration(seconds: 0), () {
          viewModel.fetchOwnerBookingsList();
        });
      },
      child: ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: viewModel.ownerBookings.matchBookings.length,
          itemBuilder: (context, index) {
            return BookingListTile(widget.store, index);
          }),
    );
  }
}

class _ViewModel {
  LoadingStatus loadingStatus;
  OwnerBookings ownerBookings;

  Function fetchOwnerBookingsList;

//  EventFieldValidations fieldValidations;
//  bool canProceedToNextScene;
//  final Function proceedToNextScene;

  _ViewModel({
    this.loadingStatus,
    this.ownerBookings,
    this.fetchOwnerBookingsList,

//    this.setEventDescription,
//    this.fieldValidations,
//    this.canProceedToNextScene,
//    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
//    _proceedToNextScene() {
//      store.dispatch(ProceedToEventSportSceneAction());
//    }

    _fetchOwnerBookingsList() {
      store.dispatch(TriggerMultipleActionsAction(
        [FetchOwnerBookingsEpicAction("123456"), UpdateOwnerBookingLoadingStatusAction(LoadingStatus.loading)],
      ));
    }

    return _ViewModel(
      loadingStatus: store.state.ownerBookingsState.loadingStatus,
      ownerBookings: store.state.ownerBookingsState.bookings,
      fetchOwnerBookingsList: _fetchOwnerBookingsList,

//      fieldValidations: store.state.eventRegistrationState.fieldValidations,
//      canProceedToNextScene: store.state.eventRegistrationState.sceneValidations.isValidEventDescriptionScene,
//      proceedToNextScene: _proceedToNextScene,
    );
  }
}
