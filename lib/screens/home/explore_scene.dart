import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/extras/custom_flexible_space_bar.dart';
import 'package:venue_app/models/Bookings.dart';
import 'package:venue_app/network/network_adapter.dart';
import 'package:venue_app/redux/actions/helper_actions.dart';
import 'package:venue_app/redux/actions/ownerBooking_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

class ExploreScene extends StatefulWidget {
  final Store<AppState> store;

  ExploreScene(this.store);

  @override
  _ExploreSceneState createState() => _ExploreSceneState();
}

class _ExploreSceneState extends State<ExploreScene> {
  final TextEditingController controller = TextEditingController();

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
//        onInitialBuild: (viewModel) {
//          if (viewModel.ownerBookings.matchBookings.length == 0 || viewModel.ownerBookings.eventBookings.length == 0) {
//            viewModel.fetchOwnerBookingsList();
//          }
//        },
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
        body: buildBookingsList(viewModel),
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
                        icon: Icon(Icons.add),
                        onPressed: () {
                          widget.store.dispatch(ProceedToEventNameSceneAction());
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
      initialIndex: viewModel.selectedSportIndex,
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
            viewModel.setSelectedSportIndex(index);
          },
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
      child: ListView(
        padding: EdgeInsets.only(top: 10.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: new Text(
              "Trending now",
              style: const TextStyle(
                  color: const Color(0xffe8e8e8),
                  fontWeight: FontWeight.w700,
                  fontFamily: "GoogleSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 24.0),
            ),
          ),
          Container(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  width: 200,
                  child: GestureDetector(
                    onTap: () => viewModel.proceedToNextScene(),
                    child: Card(
                      margin: EdgeInsets.all(5.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      clipBehavior: Clip.antiAlias,
                      elevation: 2.0,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/soccer-game-flyer-template-design-9996ca0557581c2608b9bc550f798e23_screen.jpg",
                        errorWidget: (context, url, error) => new Icon(Icons.error),
                        placeholder: (context, url) => Opacity(opacity: 0.7, child: SpinKitCircle(color: Colors.green)),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Text(
              "Events around you",
              style: const TextStyle(
                  color: const Color(0xffe8e8e8),
                  fontWeight: FontWeight.w700,
                  fontFamily: "GoogleSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 24.0),
            ),
          ),
          Container(
            height: 300,
            margin: EdgeInsets.only(bottom: 10.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 150,
              itemBuilder: (context, index) {
                return Container(
                  width: 200,
                  child: GestureDetector(
                    onTap: () => viewModel.proceedToNextScene(),
                    child: Card(
                      margin: EdgeInsets.all(5.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      clipBehavior: Clip.antiAlias,
                      elevation: 2.0,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/soccer-futsal-football-tournament-flyer-poster-template-design-cdfe1b825b823666d69791fe47a8e597_screen.jpg",
                        errorWidget: (context, url, error) => new Icon(Icons.error),
                        placeholder: (context, url) => Opacity(opacity: 0.7, child: SpinKitCircle(color: Colors.green)),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewModel {
  LoadingStatus loadingStatus;
  OwnerBookings ownerBookings;
  int selectedSportIndex;

  Function(int) setSelectedSportIndex;
  Function fetchOwnerBookingsList;

//  EventFieldValidations fieldValidations;
//  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.loadingStatus,
    this.ownerBookings,
    this.selectedSportIndex,
    this.setSelectedSportIndex,
    this.fetchOwnerBookingsList,

//    this.setEventDescription,
//    this.fieldValidations,
//    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _proceedToNextScene() {
      store.dispatch(ProceedToEventBookingSceneAction());
    }

    _setSelectedSportIndex(int index) {
      store.dispatch(SetSelectedSportIndex(index));
    }

    _fetchOwnerBookingsList() {
      store.dispatch(TriggerMultipleActionsAction(
        [FetchOwnerBookingsEpicAction("123456"), UpdateOwnerBookingLoadingStatusAction(LoadingStatus.loading)],
      ));
    }

    return _ViewModel(
      loadingStatus: store.state.ownerBookingsState.loadingStatus,
      ownerBookings: store.state.ownerBookingsState.bookings,
      selectedSportIndex: store.state.ownerBookingsState.selectedSportIndex,
      setSelectedSportIndex: _setSelectedSportIndex,
      fetchOwnerBookingsList: _fetchOwnerBookingsList,

//      fieldValidations: store.state.eventRegistrationState.fieldValidations,
//      canProceedToNextScene: store.state.eventRegistrationState.sceneValidations.isValidEventDescriptionScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
