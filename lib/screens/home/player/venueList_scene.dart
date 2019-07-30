import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/extras/custom_flexible_space_bar.dart';
import 'package:venue_app/models/VenueList.dart';
import 'package:venue_app/network/network_adapter.dart';
import 'package:venue_app/redux/actions/helper_actions.dart';

import 'package:venue_app/redux/actions/ownerBooking_actions.dart';



import 'package:venue_app/redux/actions/playerBooking_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

class VenueListScene extends StatefulWidget {
  final Store<AppState> store;

  VenueListScene(this.store);

  @override
  _VenueListSceneState createState() => _VenueListSceneState();
}

class _VenueListSceneState extends State<VenueListScene> {
  final TextEditingController controller = TextEditingController();

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        onInitialBuild: (viewModel) {
          if (viewModel.venueList.venues.length == 0) {
            viewModel.fetchVenueList();
          }
        },
        builder: (BuildContext context, _ViewModel viewModel) {
          return ModalProgressHUD(
            child: buildAppBar(viewModel),
            color: Colors.grey,
            inAsyncCall: viewModel.loadingStatus == LoadingStatus.loading,
            progressIndicator: SpinKitDoubleBounce(
              color: Colors.green,
            ),
          );
        },
      ),
    );
  }

  buildAppBar(_ViewModel viewModel) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 3.0,
              backgroundColor: Colors.white,
              expandedHeight: 110.0,
              floating: true,
              pinned: true,
              snap: true,
              flexibleSpace: CustomFlexibleSpaceBar(
                scaleValue: 1.0,
                collapseMode: CollapseMode.pin,
                titlePadding: EdgeInsets.zero,
                title: buildSportsListTabBar(viewModel),
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildLocationSettingsAndSearchBar(),
                  ],
                ),
              ),
            ),
          ];
        },
        body: buildVenueBookingsList(viewModel),
      ),
    );
  }

  Widget buildLocationSettingsAndSearchBar() {
    controller.text = "Carnival Infopark";

    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15.0),
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
                        onPressed: () {
                          widget.store.dispatch(ProceedToVenueListMapSceneAction());
                        },
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

  Widget buildSportsListTabBar(_ViewModel viewModel) {
    return DefaultTabController(
      length: 7,
      initialIndex: viewModel.selectedIndex,
      child: Theme(
        data: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent),
        child: TabBar(
          labelStyle: TextStyle(
              fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 16.8),
          unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w700, fontFamily: "GoogleSans", fontStyle: FontStyle.normal, fontSize: 16.8),
          isScrollable: true,
          labelColor: Color(0xff000000),
          unselectedLabelColor: Color(0xffdddddd),
          indicatorColor: Colors.green,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
            insets: EdgeInsets.only(bottom: 12.0),
          ),
          tabs: [
            Tab(text: "Football"),
            Tab(text: "Batminton"),
            Tab(text: "Cricket"),
            Tab(text: "Basketball"),
            Tab(text: "Swimming"),
            Tab(text: "Boxing"),
            Tab(text: "Table Tennis"),
          ],
          onTap: (index) {
            viewModel.setSelectedIndex(index);
          },
        ),
      ),
    );
  }

  Widget buildVenueBookingsList(_ViewModel viewModel) {
    return RefreshIndicator(
      displacement: 30.0,
      color: Colors.green,
      onRefresh: () {
        return Future.delayed(Duration(seconds: 0), () {
          viewModel.fetchVenueList();
        });
      },
      child: ListView.builder(
          padding: EdgeInsets.only(top: 10.0),
          itemCount: viewModel.venueList.venues.length,
          itemBuilder: (context, index) {
            return VenueListTile(widget.store, index);
          }),
    );
  }
}

class VenueListTile extends StatelessWidget {
  final Store<AppState> store;
  final int index;

  VenueListTile(this.store, this.index);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) => buildBookingListTile(viewModel),
    );
  }

  buildBookingListTile(_ViewModel viewModel) {
    List<Venue> venues = viewModel.venueList.venues;

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 30.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    venues[index].name,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w500,
                        fontFamily: "GoogleSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 21.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ButtonTheme(
                        minWidth: 50.0,
                        child: Row(
                          children: <Widget>[
                            FlatButton(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "BOOK",
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "GoogleSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15.0),
                              ),
                              onPressed: () {
                                viewModel.proceedToNextScene();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 1.0,
            margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
            color: Colors.green,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        venues[index].location,
                        style: const TextStyle(
                            color: const Color(0xff797b87),
                            fontWeight: FontWeight.w400,
                            fontFamily: "GoogleSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 13.3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        "${venues[index].availableSports.join(" ")}",
                        style: const TextStyle(
                            color: const Color(0xff797b87),
                            fontWeight: FontWeight.w400,
                            fontFamily: "GoogleSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 13.3),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 50.0,
                  width: 100.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.3)),
                        width: 48,
                        height: 50,
                        child: CachedNetworkImage(
                          height: 50,
                          width: 48,
                          fit: BoxFit.cover,
                          imageUrl: venues[index].images[0],
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                          placeholder: (context, url) =>
                              Opacity(opacity: 0.7, child: SpinKitCircle(color: Colors.green, size: 12.0)),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.3)),
                        width: 48,
                        height: 50,
                        child: CachedNetworkImage(
                          height: 50,
                          width: 48,
                          fit: BoxFit.cover,
                          imageUrl: venues[index].images[1],
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                          placeholder: (context, url) =>
                              Opacity(opacity: 0.7, child: SpinKitCircle(color: Colors.green, size: 12.0)),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ViewModel {
  LoadingStatus loadingStatus;
  VenueList venueList;
  int selectedIndex;
  int selectedFilterIndex;

  Function(int) setSelectedIndex;
  Function(int) setSelectedFilterIndex;
  Function fetchVenueList;
  Function(String) bookVenue;

//  EventFieldValidations fieldValidations;
//  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.loadingStatus,
    this.venueList,
    this.selectedIndex,
    this.selectedFilterIndex,
    this.setSelectedIndex,
    this.setSelectedFilterIndex,
    this.fetchVenueList,
    this.bookVenue,
//    this.setEventDescription,
//    this.fieldValidations,
//    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _proceedToNextScene() {
      store.dispatch(ProceedToVenueInfoSceneAction());
    }

    _setSelectedIndex(int index) {
      store.dispatch(SetSelectedIndexForMatchesOrEvents(index));
    }

    _setSelectedFilterIndex(int index) {
      store.dispatch(SetSelectedFilterIndex(index));
    }

    _fetchVenueList() {
      store.dispatch(TriggerMultipleActionsAction(
        [FetchVenueListEpicAction("123456"), UpdateVenueListLoadingStatusAction(LoadingStatus.loading)],
      ));
    }

    return _ViewModel(
      loadingStatus: store.state.playerBookingsState.loadingStatus,
      venueList: store.state.playerBookingsState.venueList,
      selectedIndex: store.state.ownerBookingsState.selectedMatchIndex,
      selectedFilterIndex: store.state.ownerBookingsState.selectedFilterIndex,
      setSelectedIndex: _setSelectedIndex,
      setSelectedFilterIndex: _setSelectedFilterIndex,
      fetchVenueList: _fetchVenueList,

//      fieldValidations: store.state.eventRegistrationState.fieldValidations,
//      canProceedToNextScene: store.state.eventRegistrationState.sceneValidations.isValidEventDescriptionScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
