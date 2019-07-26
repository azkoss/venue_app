import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/Bookings.dart';
import 'package:venue_app/redux/states/app_state.dart';

class BookingListTile extends StatelessWidget {
  final Store<AppState> store;
  final int index;

  BookingListTile(this.store, this.index);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) => buildBookingListTile(viewModel),
    );
  }

  buildBookingListTile(_ViewModel viewModel) {
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
                    viewModel.ownerBookings.matchBookings[index].name,
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w500,
                        fontFamily: "GoogleSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 21.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
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
                                "REJECT",
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "GoogleSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15.0),
                              ),
                              onPressed: () {},
                            ),
                            FlatButton(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "ACCEPT",
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "GoogleSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15.0),
                              ),
                              onPressed: () {},
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
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: 60.0,
                  width: 60.0,
                  margin: EdgeInsets.only(left: 15.0, right: 10.0),
                  child: Image.asset(
                    "assets/FakeDP.jpeg",
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        viewModel.ownerBookings.matchBookings[index].location,
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
                        "${viewModel.ownerBookings.matchBookings[index].groundName} ${viewModel.ownerBookings.matchBookings[index].date}",
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
                        "Total : ${viewModel.ownerBookings.matchBookings[index].amount} INR",
                        style: const TextStyle(
                            color: const Color(0xff797b87),
                            fontWeight: FontWeight.w400,
                            fontFamily: "GoogleSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 13.3),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ViewModel {
  OwnerBookings ownerBookings;

//  EventFieldValidations fieldValidations;
//  bool canProceedToNextScene;
//  final Function proceedToNextScene;

  _ViewModel({
    this.ownerBookings,

//    this.fieldValidations,
//    this.canProceedToNextScene,
//    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
//    _setEventDescription(String desc) {
//      Event event = store.state.eventRegistrationState.event;
//      event.description = desc;
//
//      store.dispatch(UpdateEventAction(event));
//      store.dispatch(ValidateEventDescriptionAction());
//    }
//
//    _proceedToNextScene() {
//      store.dispatch(ProceedToEventSportSceneAction());
//    }

    return _ViewModel(
      ownerBookings: store.state.ownerBookingsState.bookings,

//      fieldValidations: store.state.eventRegistrationState.fieldValidations,
//      canProceedToNextScene: store.state.eventRegistrationState.sceneValidations.isValidEventDescriptionScene,
//      proceedToNextScene: _proceedToNextScene,
    );
  }
}
