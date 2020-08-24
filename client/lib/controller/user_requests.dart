import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ktg_client/env_variables.dart';

import 'package:http/http.dart' as http;
import 'package:ktg_client/model/league.dart';
import 'package:ktg_client/model/league_invite.dart';

class UserInformation {
  UserInformation(
      {this.email,
      this.id,
      this.name,
      this.username,
      this.bets,
      this.photoUrl}) {
    leagueInvites = <LeagueInvite>[];
  }

  String email;
  String id;
  String name;
  String username;
  List<String> bets;
  String photoUrl;
  List<LeagueInvite> leagueInvites;
}

class UserRequests {
  factory UserRequests() {
    return _instance;
  }

  UserRequests._internal();

  static final UserRequests _instance = UserRequests._internal();

  UserInformation userInformation;

  Map<String, String> headers = <String, String>{};
  Map<String, String> headers2 = <String, String>{};

  GoogleSignIn get googleSignIn => _googleSignIn;

  GoogleSignInAccount _currentUser;
  String _cookie;
  String _email;

  String getEmail() {
    return _instance._email;
  }

  Future<int> refuseAcceptLeagueInvite(int inviteId, String accepDeny) async {
    await fetchUserFromServer();
    final String url = currServerPath +
        inviteRequest +
        _instance.userInformation.id +
        acceptDenyInviteRequest;
    print(url); 
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'cookie': _instance.headers2['cookie']
        },
        body: <String, String>{
          'inviteId': inviteId.toString(),
          'acceptance': accepDeny
        });
    final dynamic dataToJson = json.decode(response.body);
    print(dataToJson);
    return 1;
  }

  Future<List<LeagueInvite>> getLeagueInvites() async {
    await fetchUserFromServer();
    final String url =
        currServerPath + getCurrentUserInvites + _instance.userInformation.id;

    final http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'accept': 'application/json',
        'cookie': _instance.headers2['cookie']
      },
    );
    final dynamic dataToJson = json.decode(response.body);
    //for all league invites
    final List<LeagueInvite> templist = <LeagueInvite>[];
    for (int i = 0; i < dataToJson.length; i++) {
      final int leagueidtemp = dataToJson[i]['LeagueId'];
      final String leagueNametemp = await getLeagueName(leagueidtemp);
      final List<LeagueMember> leagueMembersTemp =
          await getLeagueMembers(leagueidtemp);
      final LeagueInvite temp = LeagueInvite(
          leagueidtemp.toString(),
          dataToJson[i]['InviteSentId'],
          dataToJson[i]['InviteReceivedId'],
          leagueNametemp,
          leagueMembersTemp);
      templist.add(temp);
    }
    _instance.userInformation.leagueInvites = templist;
    return templist;
  }

  Future<List<LeagueMember>> getLeagueMembers(int leagueId) async {
    await fetchUserFromServer();
    final String url =
        currServerPath + leaguesPath + leagueId.toString() + getLeagueUsers;

    final http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'accept': 'application/json',
        'cookie': _instance.headers2['cookie']
      },
    );
    final dynamic dataToJson = json.decode(response.body);
    final List<LeagueMember> leaguemembers = <LeagueMember>[];
    for (int i = 0; i < dataToJson.length; i++) {
      final LeagueMember tempmember =
          LeagueMember(dataToJson[i]['email'], null);
      leaguemembers.add(tempmember);
    }
    return leaguemembers;
  }

  Future<String> getLeagueName(int leagueId) async {
    await fetchUserFromServer();
    final String url = currServerPath + leaguesPath + leagueId.toString();
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'accept': 'application/json',
        'cookie': _instance.headers2['cookie']
      },
    );
    final dynamic dataToJson = json.decode(response.body);
    return dataToJson['name'];
  }

  Future<UserInformation> fetchUserFromServer() async {
    userInformation = UserInformation();
    final String url = currServerPath + getCurrentUserPath;
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'accept': 'application/json',
        'cookie': _instance.headers2['cookie']
      },
    );
    final dynamic dataToJson = json.decode(response.body);

    updateCookie2(response);

    _instance.userInformation.id = dataToJson['id'];
    _instance.userInformation.name = dataToJson['name'];
    _instance.userInformation.username = dataToJson['username'];
    _instance.userInformation.photoUrl = dataToJson['photoUrl'];
    _instance.userInformation.email = dataToJson['email'];
    _instance.userInformation.bets = dataToJson['bets'];
    return _instance.userInformation;
  }

  void updateCookie2(http.Response response) {
    final String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      final int index = rawCookie.indexOf(';');
      headers2['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  void updateCookie(HttpClientResponse response) {
    final String rawCookie = response.headers.value('set-cookie');

    if (rawCookie != null) {
      final int index = rawCookie.indexOf(';');
      headers2['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }

    if (rawCookie != null) {
      final int index = rawCookie.indexOf(';');
      _cookie = (index == -1)
          ? rawCookie
          : rawCookie.substring(rawCookie.indexOf('=') + 1, index);
    }
    _instance.headers2 = headers2;
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<int> login(String email, String password) async {
    final String url = currServerPath + loginPath;
   // print(url);

    final HttpClient httpClient = HttpClient();
    final HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(
        json.encode(<String, String>{'email': email, 'password': password})));
    final HttpClientResponse response = await request.close();

    httpClient.close();
    updateCookie(response);
    //print('Cookie: $_cookie');
    return response.statusCode;
  }

  Future<int> signUp(
      String email, String name, String username, String password) async {
    final String url = currServerPath + signUpPath;
   // print(url);

    final HttpClient httpClient = HttpClient();
    final HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(<String, String>{
      'email': email,
      'name': name,
      'username': username,
      'password': password
    })));
    final HttpClientResponse response = await request.close();

    //String reply = await response.transform(utf8.decoder).join();
    httpClient.close();

    return response.statusCode;
  }

  String pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  void handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      _currentUser = _googleSignIn.currentUser;
      // signUp(_currentUser.email, 'test', 'Test', 'testtest');
      login(_currentUser.email, 'testtest');
    } catch (error) {
      print(error);
    }
  }

  Future<void> handleSignOut() async {
    _currentUser = null;
    _googleSignIn.disconnect();
  }

  String get cookie => _cookie;

  set cookie(String value) {
    _cookie = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  GoogleSignInAccount get currentUser => _currentUser;

  set currentUser(GoogleSignInAccount value) {
    _currentUser = value;
  }
}
