import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/Bookings.dart';
import 'package:venue_app/redux/states/app_state.dart';
import 'package:venue_app/screens/home/owner/bookingList_scene.dart';

class BookingListTile extends StatelessWidget {
  final Store<AppState> store;
  final int index;

  BookingListTile(this.store, this.index);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BookingListViewModel>(
      converter: (store) => BookingListViewModel.create(store),
      builder: (BuildContext context, BookingListViewModel viewModel) => buildBookingListTile(viewModel),
    );
  }

  buildBookingListTile(BookingListViewModel viewModel) {
    List<Booking> bookings = viewModel.filteredBookings();

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
                    bookings[index].name,
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
                  child: CachedNetworkImage(
                    imageUrl: bookings[index].image,
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    placeholder: (context, url) =>
                        Opacity(opacity: 0.7, child: SpinKitCircle(color: Colors.green, size: 12.0)),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        bookings[index].location,
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
                        "${bookings[index].groundName} ${bookings[index].date}",
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
                        "Total : ${bookings[index].amount} INR",
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
