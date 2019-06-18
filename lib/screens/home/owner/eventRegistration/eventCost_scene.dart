import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/Event.dart';
import 'package:venue_app/redux/actions/eventRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

class EventCostScene extends StatelessWidget {
  final Store<AppState> store;

  EventCostScene(this.store);
  final TextEditingController controller = TextEditingController();
  final focusNode = FocusNode();

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
                  buildSubTitle1(),
                  buildEventCostField(context, viewModel),
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
        "When will your event start and end?",
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
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore etdolore magna aliqua. sed do eiusmod tempor incididunt ut",
        style: const TextStyle(
            color: const Color(0xffc7c7c7),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 16.7),
      ),
    );
  }

  Widget buildSubTitle1() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0),
      child: Text(
        "Cost of the event",
        style: const TextStyle(
            color: const Color(0xffe8e8e8),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget buildEventCostField(BuildContext context, _ViewModel viewModel) {
    controller
      ..text = viewModel.eventCost.toString()
      ..selection = TextSelection.collapsed(offset: controller.text.length);

    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: TextField(
        cursorColor: Colors.green,
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: ((value) {
          viewModel.setEventCost(value);
        }),
        decoration: InputDecoration(
          icon: Icon(Icons.attach_money),
          prefixText: "INR  ",
          suffixText: "per hour",
          contentPadding: EdgeInsets.only(bottom: 5.0),
          hintText: "100",
          errorText: viewModel.fieldValidations.isValidName == false ? "Please enter a valid cost" : null,
          fillColor: Colors.green,
        ),
      ),
    );
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
  int eventCost;
  final Function(String) setEventCost;

  EventFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.eventCost,
    this.setEventCost,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _setEventCost(String cost) {
      Event event = store.state.eventRegistrationState.event;
      event.cost = cost == "" ? 0 : int.parse(cost);

      store.dispatch(UpdateEventAction(event));
      store.dispatch(ValidateEventCostAction());
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToEventAgeGroupSceneAction());
    }

    return _ViewModel(
      eventCost: store.state.eventRegistrationState.event.cost ?? 0,
      setEventCost: _setEventCost,
      fieldValidations: store.state.eventRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.eventRegistrationState.sceneValidations.isValidEventCostScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
