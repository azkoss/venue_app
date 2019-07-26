import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/VenueList.dart';
import 'package:venue_app/network/network_adapter.dart';
import 'package:venue_app/redux/actions/helper_actions.dart';
import 'package:venue_app/redux/actions/ownerBookings_actions.dart';
import 'package:venue_app/redux/actions/playerBooking_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

class VenueListMapScene extends StatefulWidget {
  final Store<AppState> store;

  VenueListMapScene(this.store);

  @override
  _VenueListMapSceneState createState() => _VenueListMapSceneState();
}

class _VenueListMapSceneState extends State<VenueListMapScene> {
  final TextEditingController controller = TextEditingController();

  final focusNode = FocusNode();

  Completer<GoogleMapController> mapController = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.014538, 76.363382),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(10.014538, 76.363382),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  BitmapDescriptor selectedMarkerIcon;
  BitmapDescriptor unSelectedMarkerIcon;
  Venue selectedVenue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        onInitialBuild: (viewModel) {
          loadMarkerAnnotation();
//          if (viewModel.venueList.venues.length == 0) {
          viewModel.fetchVenueList();
//          }
          selectedVenue = viewModel.venueList.venues.first;
        },
        builder: (BuildContext context, _ViewModel viewModel) {
          return ModalProgressHUD(
            child: buildMapStack(viewModel),
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

  void loadMarkerAnnotation() {
    BitmapDescriptor.fromAssetImage(
            createLocalImageConfiguration(context, size: Size(48, 48)), "assets/annotationSelected.png")
        .then((onValue) {
      selectedMarkerIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(createLocalImageConfiguration(context, size: Size(48, 48)), "assets/annotation.png")
        .then((onValue) {
      unSelectedMarkerIcon = onValue;
    });
  }

  Widget buildMapStack(_ViewModel viewModel) {
    return Stack(
      children: <Widget>[
        buildMapView(viewModel),
//        buildLocationField(),
        buildVenueBookingsList(viewModel),
      ],
    );
  }

  Widget buildMapView(_ViewModel viewModel) {
    double latitude = selectedVenue == null ? 10.014538 : double.parse(selectedVenue.latitude);
    double longitude = selectedVenue == null ? 76.363382 : double.parse(selectedVenue.longitude);

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14.4746,
      ),
      myLocationEnabled: true,
      compassEnabled: true,
      markers: markersForMapView(viewModel),
      onMapCreated: (GoogleMapController controller) {
        mapController.complete(controller);
      },
    );
  }

  Set<Marker> markersForMapView(_ViewModel viewModel) {
    return Set.from(List.generate(viewModel.venueList.venues.length, (index) {
      Venue venue = viewModel.venueList.venues[index];
      return Marker(
        markerId: MarkerId(venue.latitude),
        position: LatLng(double.parse(venue.latitude), double.parse(venue.longitude)),
        icon: selectedVenue == venue ? selectedMarkerIcon : unSelectedMarkerIcon,
      );
    }));
  }

  Widget buildLocationField() {
    controller.text = "Carnival Infopark";

    return SafeArea(
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

  Widget buildVenueBookingsList(_ViewModel viewModel) {
    return Positioned(
      bottom: 35,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.transparent,
        height: 125,
        child: PageView.builder(
          itemCount: viewModel.venueList.venues.length,
          controller: PageController(initialPage: 0, viewportFraction: 0.8),
          onPageChanged: (index) async {
            selectedVenue = viewModel.venueList.venues[index];

            final GoogleMapController controller = await mapController.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(double.parse(selectedVenue.latitude), double.parse(selectedVenue.longitude)),
//                tilt: 59.440717697143555,
                zoom: 18.4746)));

            setState(() {});
          },
          itemBuilder: (context, index) {
            return VenueListPageTile(widget.store, index);
          },
        ),
      ),
    );
  }
}

class VenueListPageTile extends StatelessWidget {
  final Store<AppState> store;
  final int index;

  VenueListPageTile(this.store, this.index);

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
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 35.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    venues[index].name,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w500,
                        fontFamily: "GoogleSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "BOOK",
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                            fontFamily: "GoogleSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.7),
                      ),
                    ),
                    onTap: () {
                      viewModel.proceedToNextScene();
                    },
                  )
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.green,
            ),
            Container(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    venues[index].location,
                    style: const TextStyle(
                        color: const Color(0xff797b87),
                        fontWeight: FontWeight.w400,
                        fontFamily: "GoogleSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 13.3),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star, color: Color(0xff797b87), size: 15),
                      Text(
                        "4.0",
                        style: const TextStyle(
                            color: const Color(0xff797b87),
                            fontWeight: FontWeight.w400,
                            fontFamily: "GoogleSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 13.3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(padding: const EdgeInsets.all(3.0), child: Icon(Icons.ac_unit)),
                    Padding(padding: const EdgeInsets.all(3.0), child: Icon(Icons.store))
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                Container(
                  height: 40.0,
                  width: 80.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.3)),
                        width: 38,
                        height: 40,
                        child: CachedNetworkImage(
                          height: 40,
                          width: 38,
                          fit: BoxFit.cover,
                          imageUrl: venues[index].images[0],
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                          placeholder: (context, url) =>
                              Opacity(opacity: 0.7, child: SpinKitCircle(color: Colors.green, size: 12.0)),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.3)),
                        width: 38,
                        height: 40,
                        child: CachedNetworkImage(
                          height: 40,
                          width: 38,
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
            )
          ],
        ),
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
