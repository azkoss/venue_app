import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:redux/redux.dart';
import 'package:venue_app/models/User.dart';
import 'package:venue_app/redux/actions/userRegistration_actions.dart';
import 'package:venue_app/redux/states/app_state.dart';

class TutorialScene extends StatefulWidget {
  final Store<AppState> store;

  TutorialScene(this.store);

  @override
  _TutorialSceneState createState() => _TutorialSceneState();
}

class _TutorialSceneState extends State<TutorialScene> {
  final pageController = PageController();
  var currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.create(store),
      builder: (BuildContext context, viewModel) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                buildPageView(context, viewModel),
                buildPageControl(context, viewModel),
                buildBottomText(context, viewModel),
                buildNextButton(context, viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  buildPageView(BuildContext context, _ViewModel viewModel) {
    return PageView.builder(
      itemCount: 3,
      controller: pageController,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return buildDiscoverScreen();
            break;
          case 1:
            return buildScheduleScreen();
            break;
          case 2:
            return buildPlayScreen();
            break;
        }
      },
      onPageChanged: (int index) {
        viewModel.setTutorialIndex(index);
        currentPageNotifier.value = index;
      },
    );
  }

  buildPageControl(BuildContext context, _ViewModel viewModel) {
    return Positioned(
      bottom: 15.0,
      left: 10.0,
      child: CirclePageIndicator(
        dotColor: Colors.black12,
        selectedDotColor: Colors.green,
        size: 15.0,
        selectedSize: 15.0,
        itemCount: 3,
        currentPageNotifier: currentPageNotifier,
      ),
    );
  }

  buildBottomText(BuildContext context, _ViewModel viewModel) {
    return Positioned(
      bottom: 12.0,
      left: 0.0,
      right: 0.0,
      child: Center(
        child: Text(
          viewModel.tutorialIndex != 2 ? "SCROLL RIGHT" : "",
          style: const TextStyle(
              color: const Color(0xff30b536),
              fontWeight: FontWeight.w700,
              fontFamily: "GoogleSans",
              fontStyle: FontStyle.normal,
              fontSize: 18.3),
        ),
      ),
    );
  }

  buildNextButton(BuildContext context, _ViewModel viewModel) {
    Widget nextButton;

    if (viewModel.tutorialIndex == 2) {
      nextButton = Positioned(
        bottom: 0.0,
        right: 0.0,
        child: Container(
          height: 60.0,
          width: 120.0,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0)),
          ),
          child: FlatButton(
            onPressed: () {
              viewModel.proceedToNextScene();
              print("Halla");
            },
            child: Text(
              "Lets go",
              style: const TextStyle(
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w400,
                  fontFamily: "GoogleSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 23.3),
            ),
          ),
        ),
      );
    } else {
      nextButton = Positioned(
        bottom: 0.0,
        right: 0.0,
        child: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeIn);
//            viewModel.proceedToNextScene();
          },
          color: Colors.green,
        ),
      );
    }

    return nextButton;
  }

  buildDiscoverScreen() {
    return Padding(
      padding: EdgeInsets.only(top: 80.0, left: 20.0, right: 20.0),
      child: Container(
        child: Column(
          children: <Widget>[
            new Text(
              "Discover",
              style: const TextStyle(
                  color: const Color(0xff3e5566),
                  fontWeight: FontWeight.w500,
                  fontFamily: "GoogleSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 33.3),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0, left: 60.0, right: 60.0),
              child: Container(
                child: Image.asset("assets/discoverGlobe.png"),
                height: 220,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0, left: 25.0, right: 25.0),
              child: Text(
                "Find out the best sports venues around the world. We support all the sports that you wish to playfor a long time with your friends.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: const Color(0xff575e63),
                    fontWeight: FontWeight.w400,
                    fontFamily: "GoogleSans",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildScheduleScreen() {
    return Padding(
      padding: EdgeInsets.only(top: 80.0, left: 20.0, right: 20.0),
      child: Container(
        child: Column(
          children: <Widget>[
            new Text(
              "Schedule",
              style: const TextStyle(
                  color: const Color(0xff3e5566),
                  fontWeight: FontWeight.w500,
                  fontFamily: "GoogleSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 33.3),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0, left: 60.0, right: 60.0),
              child: Container(
                child: Container(
                  child: Image.asset("assets/scheduleGirl.png"),
                  height: 220,
                ),
                height: 220,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0, left: 25.0, right: 25.0),
              child: Text(
                "Book your slots with no initial charges and easy cancelation policies. Nobody gonna stop you from playing on your favorite venue.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: const Color(0xff575e63),
                    fontWeight: FontWeight.w400,
                    fontFamily: "GoogleSans",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildPlayScreen() {
    return Padding(
      padding: EdgeInsets.only(top: 80.0, left: 20.0, right: 20.0),
      child: Container(
        child: Column(
          children: <Widget>[
            new Text(
              "Play",
              style: const TextStyle(
                  color: const Color(0xff3e5566),
                  fontWeight: FontWeight.w500,
                  fontFamily: "GoogleSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 33.3),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0, left: 60.0, right: 60.0),
              child: Container(
                child: Image.asset("assets/playBoy.png"),
                height: 220,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0, left: 25.0, right: 25.0),
              child: Text(
                "Find out the best sports venues around the world. We support all the sports that you wish to playfor a long time with your friends.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: const Color(0xff575e63),
                    fontWeight: FontWeight.w400,
                    fontFamily: "GoogleSans",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewModel {
  int tutorialIndex;
  final Function(int) setTutorialIndex;

  UserFieldValidations fieldValidations;
  bool canProceedToNextScene;
  final Function proceedToNextScene;

  _ViewModel({
    this.tutorialIndex,
    this.setTutorialIndex,
    this.fieldValidations,
    this.canProceedToNextScene,
    this.proceedToNextScene,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _setTutorialIndex(int tutorialIndex) {
      User user = store.state.userRegistrationState.user;
      user.tutorialIndex = tutorialIndex;
      store.dispatch(UpdateUserAction(user));
    }

    _proceedToNextScene() {
      store.dispatch(ProceedToOwnerOrPlayerSceneAction());
    }

    return _ViewModel(
      tutorialIndex: store.state.userRegistrationState.user.tutorialIndex,
      setTutorialIndex: _setTutorialIndex,
      fieldValidations: store.state.userRegistrationState.fieldValidations,
      canProceedToNextScene: true,
      proceedToNextScene: _proceedToNextScene,
    );
  }
}
