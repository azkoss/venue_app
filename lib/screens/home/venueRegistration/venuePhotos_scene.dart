import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/redux/states/app_state.dart';

import 'package:venue_app/models/Venue.dart';
import 'package:venue_app/redux/actions/venueRegistration_actions.dart';

class VenuePhotosScene extends StatelessWidget {
  final Store<AppState> store;

  VenuePhotosScene(this.store);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
          converter: (store) => _ViewModel.create(store),
          builder: (BuildContext context, _ViewModel viewModel) => ListView(
                children: <Widget>[
                  buildTitle(),
                  buildDescription(),
                  buildSubTitle(),
                  buildPhotosContainer(context, viewModel),
                  buildNextButton(context, viewModel),
                ],
              )),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: Text(
        "We need some photos of your venue",
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
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. sed do eiusmod tempor incididunt ut",
        style: const TextStyle(
            color: const Color(0xffc7c7c7),
            fontWeight: FontWeight.w400,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 16.7),
      ),
    );
  }

  Widget buildSubTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0),
      child: Text(
        "Add your photos",
        style: const TextStyle(
            color: const Color(0xffe8e8e8),
            fontWeight: FontWeight.w700,
            fontFamily: "GoogleSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget buildPhotosContainer(BuildContext context, _ViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
      child: Container(
        height: 200,
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(5, (index) {
            return Card(
              margin: EdgeInsets.all(8.0),
              elevation: 0.0,
              shape: Border.all(color: Colors.grey, width: 0.3),
              child: GestureDetector(
                child: Container(
                  child: _photoAtIndex(index, viewModel),
                ),
                onTap: () => _showDialogueWithContext(context, viewModel, index),
              ),
            );
          }),
        ),
      ),
    );
  }

  _showDialogueWithContext(BuildContext context, _ViewModel viewModel, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
          elevation: 2.0,
          children: <Widget>[
            FlatButton(
              child: Text(
                "Take a picture",
                style: const TextStyle(fontStyle: FontStyle.normal, fontSize: 18.0),
              ),
              onPressed: () {
                _pickImageFromType(context, viewModel, ImageSource.camera, index);
              },
            ),
            FlatButton(
              child: Text(
                "Pick from gallery",
                style: const TextStyle(fontStyle: FontStyle.normal, fontSize: 18.0),
              ),
              onPressed: () {
                _pickImageFromType(context, viewModel, ImageSource.gallery, index);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _photoAtIndex(int index, _ViewModel viewModel) {
    Widget widget;

    if (index <= viewModel.photos.length - 1) {
      widget = Image.file(viewModel.photos[index], fit: BoxFit.cover);
    } else {
      widget = Image.asset("assets/addImage.png");
    }

    return widget;
  }

  _pickImageFromType(BuildContext context, _ViewModel viewModel, ImageSource source, int indexForImage) async {
    ImagePicker.pickImage(source: source).then((file) {
      Navigator.pop(context);
      viewModel.insertPhoto(file, indexForImage);
    }).catchError((error) {
      print(error);
    });
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
  List photos;
  final Function(File, int) insertPhoto;

  VenueFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.photos,
    this.insertPhoto,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _insertPhoto(File file, int index) {
      Venue venue = store.state.venueRegistrationState.venue;
      if (venue.photos.length == 0 || index > venue.photos.length - 1) {
        venue.photos.add(file);
      } else {
        venue.photos[index] = file;
      }

      store.dispatch(UpdateVenueAction(venue));
      store.dispatch(ValidateVenuePhotosAction());
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToVenueAmenitiesSceneAction());
    }

    return _ViewModel(
      photos: store.state.venueRegistrationState.venue.photos,
      insertPhoto: _insertPhoto,
      fieldValidations: store.state.venueRegistrationState.fieldValidations,
      canProceedToNextScene: store.state.venueRegistrationState.sceneValidations.isValidVenuePhotosScene,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
