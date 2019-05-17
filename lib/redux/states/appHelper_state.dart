class AppHelperState {
  final bool shouldShowAlert;
  final String title;
  final String message;

  AppHelperState({this.shouldShowAlert, this.title, this.message});

  factory AppHelperState.initial() {
    return AppHelperState(
      shouldShowAlert: false,
      title: "",
      message: "",
    );
  }

  AppHelperState copyWith({bool shouldShowAlert, String title, String message}) {
    return AppHelperState(
      shouldShowAlert: shouldShowAlert ?? this.shouldShowAlert,
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }
}
