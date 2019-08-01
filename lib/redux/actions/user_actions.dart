class GetUsersEpicAction {
  final String token;

  GetUsersEpicAction(this.token);
}

class GetUserProfileEpicAction {
  final String token;

  GetUserProfileEpicAction(this.token);
}

class UserImageListEpicAction{
  final String token;

  UserImageListEpicAction(this.token);
}

class UserImageDetailsEpicAction {
  final String token;

  UserImageDetailsEpicAction(this.token);
}

class CreateUserImageEpicAction {
  final String token;
  final String imageUrl;
  CreateUserImageEpicAction(this.token, this.imageUrl);
}

class DeleteUserImageEpicAction {
  final String token;
  final String imageUrl;

  DeleteUserImageEpicAction(this.token, this.imageUrl);
}