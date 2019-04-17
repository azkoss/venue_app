import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/redux/states/app_state.dart';

import '../../models/Venue.dart';
import '../../redux/actions/venueRegistration_actions.dart';

class VenueAvailableSportsScene extends StatefulWidget {
  final Store<AppState> store;

  VenueAvailableSportsScene(this.store);

  @override
  _VenueAvailableSportsSceneState createState() => _VenueAvailableSportsSceneState();
}

class _VenueAvailableSportsSceneState extends State<VenueAvailableSportsScene> {
  Amenities hh = Amenities.parking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
          converter: (store) => _ViewModel.create(store),
          builder: (BuildContext context, _ViewModel viewModel) => ListView(
                children: <Widget>[
                  buildTitle(),
                  buildDescription(),
                  buildAvailableSportsList(context, viewModel),
                  buildNextButton(context, viewModel),
                ],
              )),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Text(
        "What are the amneties provided in venue?",
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

  Widget buildAvailableSportsList(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 8.0, right: 20.0),
      child: Column(
        children: _buildAvailableSportsCheckBoxes(context, viewModel),
      ),
    );
  }

  List<Widget> _buildAvailableSportsCheckBoxes(BuildContext context, _ViewModel viewModel) {
    List<Widget> widgets = [];

    for (Sports sport in Sports.values) {
      var sportModel = Sport();
      sportModel.name = sport;

      var row = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Checkbox(
              checkColor: Colors.green,
              activeColor: Colors.white10,
              value: viewModel.sports.contains(sportModel),
              onChanged: (value) {
                viewModel.addOrRemoveSport(sportModel);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: _iconForSports(sport),
          ),
          Text(
            _textForSports(sport),
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

      if (viewModel.sports.contains(sportModel)) {
        var venueTypeFields = _buildVenueTypesForSport(sportModel, context, viewModel);
        widgets.add(venueTypeFields);
      }
    }

    return widgets;
  }

  Widget _buildVenueTypesForSport(Sport sport, BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Add your venue types here",
            style: const TextStyle(
                color: const Color(0xffe8e8e8),
                fontWeight: FontWeight.w700,
                fontFamily: "GoogleSans",
                fontStyle: FontStyle.normal,
                fontSize: 24.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _venueTypeListFromModel(sport, context, viewModel),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _venueTypeListFromModel(Sport sport, BuildContext context, _ViewModel viewModel) {
    List<Widget> widgets = [];

    int index = viewModel.sports.indexOf(sport);
    List<String> groundNames = viewModel.sports[index].groundNames ?? [];

    for (String groundName in groundNames) {
      TextEditingController textController = TextEditingController(text: groundName);
      textController.selection = TextSelection.collapsed(offset: textController.text.length);
      var widget = Container(
        width: 130.0,
        height: 60.0,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.3)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Image.asset("assets/roundPlus.png"),
                ),
                Flexible(
                  child: TextField(
                    cursorColor: Colors.green,
                    controller: textController,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      int index = groundNames.indexOf(groundName);
                      groundNames[index] = value;
                      viewModel.updateGroundNamesForSport(groundNames, sport);
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 5.0),
                      hintText: "Ex: Ground 1",
                      fillColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      widgets.add(widget);
    }

    widgets.add(_buildAdditionalContainer(sport, context, viewModel));

    return widgets;
  }

  Widget _buildAdditionalContainer(Sport sport, BuildContext context, _ViewModel viewModel) {
    TextEditingController textController = TextEditingController(text: "");
    textController.selection = TextSelection.collapsed(offset: textController.text.length);

    return Container(
      width: 130.0,
      height: 60.0,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.3)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Image.asset("assets/roundPlus.png"),
              ),
              Flexible(
                child: TextField(
                  cursorColor: Colors.green,
                  controller: textController,
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    viewModel.addGroundNameForSport(value, sport);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5.0),
                    hintText: "Ex: Ground 1",
                    fillColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _textForSports(Sports sport) {
    String text;
    switch (sport) {
      case Sports.footBall:
        text = "Football";
        break;
      case Sports.badminton:
        text = "Badminton";
        break;
      case Sports.cricket:
        text = "Cricket";
        break;
      case Sports.swimming:
        text = "Swimming";
        break;
      case Sports.boxing:
        text = "Boxing";
        break;
      case Sports.tableTennis:
        text = "Table Tennis";
        break;
      case Sports.basketBall:
        text = "Basket Ball";
        break;
    }

    return text;
  }

  Widget _iconForSports(Sports sport) {
    Widget icon;
    switch (sport) {
      case Sports.footBall:
        icon = Icon(Icons.folder_open);
        break;
      case Sports.badminton:
        icon = Icon(Icons.battery_std);
        break;
      case Sports.cricket:
        icon = Icon(Icons.chevron_right);
        break;
      case Sports.swimming:
        icon = Image.asset("assets/swimming.png");
        break;
      case Sports.boxing:
        icon = Image.asset("assets/boxing.png");
        break;
      case Sports.tableTennis:
        icon = Image.asset("assets/tableTennis.png");
        break;
      case Sports.basketBall:
        icon = Image.asset("assets/basketBall.png");
        break;
    }

    return icon;
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
  List<Sport> sports;
  final Function(Sport) addOrRemoveSport;
  final Function(List<String>, Sport) updateGroundNamesForSport;
  final Function(String, Sport) addGroundNameForSport;

  VenueFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.sports,
    this.addOrRemoveSport,
    this.updateGroundNamesForSport,
    this.addGroundNameForSport,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _addOrRemoveSport(Sport sport) {
      Venue venue = store.state.venueRegistrationState.venue;
      if (venue.sports.contains(sport)) {
        venue.sports.remove(sport);
      } else {
        venue.sports.add(sport);
      }

      store.dispatch(UpdateVenueAction(venue));
      store.dispatch(ValidateVenueSportsAction());
    }

    _updateGroundNames(List<String> groundNames, Sport sport) {
      Venue venue = store.state.venueRegistrationState.venue;
      if (venue.sports.contains(sport)) {
        int index = venue.sports.indexOf(sport);
        Sport sportModel = venue.sports[index];
        sportModel.groundNames = groundNames;
      }

      store.dispatch(UpdateVenueAction(venue));
      store.dispatch(ValidateVenueSportsAction());
    }

    _addGroundNameForSport(String groundName, Sport sport) {
      Venue venue = store.state.venueRegistrationState.venue;
      if (venue.sports.contains(sport)) {
        int index = venue.sports.indexOf(sport);
        Sport sportModel = venue.sports[index];
        var groundNames = sportModel.groundNames ?? [];
        groundNames.add(groundName);
        sportModel.groundNames = groundNames;
      }

      store.dispatch(UpdateVenueAction(venue));
      store.dispatch(ValidateVenueSportsAction());
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToVenueTimeSlotSceneAction());
    }

    return _ViewModel(
      sports: store.state.venueRegistrationState.venue.sports,
      addOrRemoveSport: _addOrRemoveSport,
      updateGroundNamesForSport: _updateGroundNames,
      addGroundNameForSport: _addGroundNameForSport,
      fieldValidations: store.state.venueRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.venueRegistrationState.sceneValidations.isValidVenueSportsScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
