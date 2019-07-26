import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/Event.dart';
import 'package:venue_app/redux/actions/eventRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

class EventDateScene extends StatelessWidget {
  final Store<AppState> store;

  EventDateScene(this.store);
  final TextEditingController controller = TextEditingController();
  final focusNode = FocusNode();

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  InputType inputType = InputType.both;
  DateTime date;

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
                  buildEventStartDateField(context, viewModel),
                  buildSubTitle2(),
                  buildEventEndDateField(context, viewModel),
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
        "Start Date",
        style: const TextStyle(
            color: const Color(0xffe8e8e8),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget buildEventStartDateField(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
      child: DateTimePickerFormField(
        firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        initialValue: viewModel.startDate,
        resetIcon: null,
        inputType: inputType,
        format: formats[inputType],
        editable: false,
        decoration: InputDecoration(
          labelText: 'Start date for event',
          errorText: !viewModel.fieldValidations.isValidStartDate ? "Please enter a valid start date" : null,
          hasFloatingPlaceholder: false,
          contentPadding: EdgeInsets.only(bottom: 3.0),
          fillColor: Colors.green,
        ),
        onChanged: (value) {
          viewModel.setEventStartDate(value);
        },
      ),
    );
  }

  Widget buildSubTitle2() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0),
      child: Text(
        "End Date",
        style: const TextStyle(
            color: const Color(0xffe8e8e8),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget buildEventEndDateField(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
      child: DateTimePickerFormField(
        firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        initialValue: viewModel.endDate,
        resetIcon: null,
        inputType: inputType,
        format: formats[inputType],
        editable: false,
        decoration: InputDecoration(
          labelText: 'End date for event',
          errorText: !viewModel.fieldValidations.isValidEndDate ? "Please enter a valid end date" : null,
          hasFloatingPlaceholder: false,
          contentPadding: EdgeInsets.only(bottom: 3.0),
          fillColor: Colors.green,
        ),
        onChanged: (value) {
          viewModel.setEventEndDate(value);
        },
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
  DateTime startDate;
  DateTime endDate;
  final Function(DateTime) setEventStartDate;
  final Function(DateTime) setEventEndDate;

  EventFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.startDate,
    this.endDate,
    this.setEventStartDate,
    this.setEventEndDate,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _setEventStartDate(DateTime date) {
      Event event = store.state.eventRegistrationState.event;
      event.startDate = date;

      store.dispatch(UpdateEventAction(event));
      store.dispatch(ValidateEventStartDateAction());
    }

    _setEventEndDate(DateTime date) {
      Event event = store.state.eventRegistrationState.event;
      event.endDate = date;

      store.dispatch(UpdateEventAction(event));
      store.dispatch(ValidateEventEndDateAction());
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToEventCostSceneAction());
    }

    return _ViewModel(
      startDate: store.state.eventRegistrationState.event.startDate,
      endDate: store.state.eventRegistrationState.event.endDate,
      setEventStartDate: _setEventStartDate,
      setEventEndDate: _setEventEndDate,
      fieldValidations: store.state.eventRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.eventRegistrationState.sceneValidations.isValidEventDateScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
