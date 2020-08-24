import 'package:ktg_client/controller/user_requests.dart';
import 'package:ktg_client/model/user.dart';

class Session {
  Session() {
    userRequests = UserRequests();
  }

  User currentUser;
  UserRequests userRequests;
  String sessionToken;

  void logOut() {
    currentUser = null;
  }

  void logIn(User user) {
    currentUser = user;
  }
}
