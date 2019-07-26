import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/Event.dart';
import 'package:venue_app/models/Venue.dart';
import 'package:venue_app/redux/actions/eventRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

class EventSportScene extends StatefulWidget {
  final Store<AppState> store;

  EventSportScene(this.store);

  @override
  _EventSportSceneState createState() => _EventSportSceneState();
}

class _EventSportSceneState extends State<EventSportScene> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => SafeArea(
              child: ListView(
                children: <Widget>[
                  buildTitle(),
                  buildDescription(),
                  buildSportsList(context, viewModel),
                  buildNextButton(context, viewModel),
                ],
              ),
            ),
      ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Text(
        "Select the sport on which the event is based on",
        style: const TextStyle(
            color: const Color(0xff000000),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 33.0),
      ),
    );
  }

  Widget buildDescription() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: Text(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. sed do eiusmod tempor incididunt ut labore et.",
        style: const TextStyle(
            color: const Color(0xffc7c7c7),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 16.7),
      ),
    );
  }

  Widget buildSportsList(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 8.0, right: 20.0),
      child: Column(
        children: _buildSportRadioButtons(context, viewModel),
      ),
    );
  }

  List<Widget> _buildSportRadioButtons(BuildContext context, _ViewModel viewModel) {
    List<Widget> widgets = [];

    for (Sports sport in Sports.values) {
      var row = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
//            decoration: ShapeDecoration(shape: Border.all(color: Colors.grey)),
            child: Radio(
              activeColor: Colors.green,
              groupValue: viewModel.sport,
              value: sport,
              onChanged: (value) {
                viewModel.selectSport(sport);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: Sport.displayIcon(sport),
          ),
          Text(
            Sport.displayName(sport),
            style: const TextStyle(
                color: const Color(0xff000000),
                fontWeight: FontWeight.w400,
                fontFamily: "GoogleSans",
                fontStyle: FontStyle.normal,
                fontSize: 20.5),
          ),
        ],
      );

      widgets.add(row);
    }

    return widgets;
  }

  Widget buildNextButton(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(top: 30.0, right: 20.0, bottom: 20.0),
      child: Container(
        alignment: Alignment.topRight,
        child: FloatingActionButton(
          onPressed: () {
            viewModel.canProceedToNextScene ? viewModel.proceedToNextScene() : null;
          },
          backgroundColor: viewModel.canProceedToNextScene ? Colors.green : Colors.grey,
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}

class _ViewModel {
  Sports sport;
  final Function(Sports) selectSport;

  EventFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.sport,
    this.selectSport,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _selectSport(Sports sport) {
      Event event = store.state.eventRegistrationState.event;
      event.sport = sport;

      store.dispatch(UpdateEventAction(event));
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToEventPhotosSceneAction());
    }

    return _ViewModel(
      sport: store.state.eventRegistrationState.event.sport,
      selectSport: _selectSport,
      fieldValidations: store.state.eventRegistrationState.fieldValidations,
      canProceedToNextScene: true,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
