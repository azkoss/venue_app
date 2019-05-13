import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/Event.dart';
import 'package:venue_app/redux/actions/eventRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

import '../../redux/actions/eventRegistration_actions.dart';

class EventAgeGroupScene extends StatefulWidget {
  final Store<AppState> store;

  EventAgeGroupScene(this.store);

  @override
  _EventAgeGroupSceneState createState() => _EventAgeGroupSceneState();
}

class _EventAgeGroupSceneState extends State<EventAgeGroupScene> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    buildTitle(),
                    buildDescription(),
                    buildAgeGroupList(context, viewModel),
                  ],
                ),
                buildLetsGoButton(context, viewModel),
              ],
            ),
      ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Text(
        "Is there any specific age group for your event",
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

  Widget buildAgeGroupList(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 8.0, right: 20.0),
      child: Column(
        children: _buildAgeGroupRadioButtons(context, viewModel),
      ),
    );
  }

  List<Widget> _buildAgeGroupRadioButtons(BuildContext context, _ViewModel viewModel) {
    List<Widget> widgets = [];

    for (AgeGroup ageGroup in AgeGroup.values) {
      var row = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
//            decoration: ShapeDecoration(shape: Border.all(color: Colors.grey)),
            child: Radio(
              activeColor: Colors.green,
              groupValue: viewModel.ageGroup,
              value: ageGroup,
              onChanged: (value) {
                viewModel.selectAgeGroup(ageGroup);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: Event.displayIconForAgeGroup(ageGroup),
          ),
          Text(
            Event.displayNameForAgeGroup(ageGroup),
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

  Widget buildLetsGoButton(BuildContext context, _ViewModel viewModel) {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      left: 0.0,
      child: GestureDetector(
        onTap: () => viewModel.proceedToNextScene(),
        child: Container(
          height: 60.0,
          color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LET’S GO",
                style: const TextStyle(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w500,
                    fontFamily: "GoogleSans",
                    fontStyle: FontStyle.normal,
                    fontSize: 23.3),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  AgeGroup ageGroup;
  final Function(AgeGroup) selectAgeGroup;

  EventFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.ageGroup,
    this.selectAgeGroup,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _selectAgeGroup(AgeGroup ageGroup) {
      Event event = store.state.eventRegistrationState.event;
      event.ageGroup = ageGroup.index;

      store.dispatch(UpdateEventAction(event));
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToEventPhotosSceneAction());
    }

    return _ViewModel(
      ageGroup: AgeGroup.values[store.state.eventRegistrationState.event.ageGroup ?? 0],
      selectAgeGroup: _selectAgeGroup,
      fieldValidations: store.state.eventRegistrationState.fieldValidations,
      canProceedToNextScene: true,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
