import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ktg_client/controller/user_requests.dart';
import 'package:ktg_client/main.dart';
import 'package:ktg_client/model/team_info.dart';
import 'package:ktg_client/model/league.dart';
import 'package:ktg_client/model/game_info.dart';
import 'package:ktg_client/env_variables.dart';
import 'package:flutter/foundation.dart';

class ApiHandler with ChangeNotifier {
  ApiHandler() {
    gamesAreCached = false;
    gamesAreLoading = false;

    leaguesAreCached = false;
    leaguesAreLoading = false;
  }

  bool gamesAreCached;
  bool gamesAreLoading;

  bool leaguesAreCached;
  bool leaguesAreLoading;

  String nflseason;
  String nbaseason;
  String week;
  List<String> data = <String>[];

  List<GameInfo> games = <GameInfo>[];
  List<League> leagues = <League>[];
  List<TeamInfo> teamjson = <TeamInfo>[];

  void deleteCachedGames() {
    games.clear();
    gamesAreCached = false;
    notifyListeners();
  }

  List<GameInfo> getGames() {
    if (gamesAreCached)
      return games;
    else {
      if (gamesAreLoading == false) {
        gamesAreLoading = true;
        getGamesByWeek();
      }
      return <GameInfo>[
        GameInfo(null, TeamInfo(null, null, null, null),
            TeamInfo(null, null, null, null), null, null, null, null, null),
        GameInfo(null, TeamInfo(null, null, null, null),
            TeamInfo(null, null, null, null), null, null, null, null, null),
        GameInfo(null, TeamInfo(null, null, null, null),
            TeamInfo(null, null, null, null), null, null, null, null, null)
      ];
    }
  }

  /* Future<List<GameInfo>> getGamesInASpecificLeague(int leagueId) async {
    List<GameInfo> gameInLeague=[];
    if (gamesAreCached) {
      http.Response response;
      String getMatchesInLeagueURL =
          'http://104.248.19.12:5050/api/v1/leagues/' +
              leagueId.toString() +
              '/games';

      response =
          await http.get(Uri.parse(getMatchesInLeagueURL), headers: headers);

      final String dataToJson = json.decode(response.body);

      print('Status Code:' + response.statusCode.toString());



      for (int i = 0; i < dataToJson.length; i++) {
        if(dataToJson[i]['GameID']==){

        }
      }
    } else {
      if (gamesAreLoading == false) {
        gamesAreLoading = true;
        getGamesByWeek();
      }
      return <GameInfo>[
        GameInfo(null, TeamInfo(null, null, null, null),
            TeamInfo(null, null, null, null), null, null, null, null, null),
        GameInfo(null, TeamInfo(null, null, null, null),
            TeamInfo(null, null, null, null), null, null, null, null, null),
        GameInfo(null, TeamInfo(null, null, null, null),
            TeamInfo(null, null, null, null), null, null, null, null, null)
      ];
    }
  }*/

  void printGames() {
    for (int i = 0; i < games.length; i++) {
      print(games[i].hometeam.name + ' VS ' + games[i].awayteam.name + '\n');
      print(games[i].homescore.toString() +
          ' - ' +
          games[i].awayscore.toString());
    }
  }

  String teamName(int id) {
    for (int i = 0; i < teamjson.length; i++) {
      if (teamjson[i].getId() == id) {
        return teamjson[i].getName();
      }
    }
    return 'Unknown';
  }

  TeamInfo getTeamInfo(int id) {
    for (int i = 0; i < teamjson.length; i++) {
      if (teamjson[i].getId() == id) {
        return teamjson[i];
      }
    }
    return null;
  }

  Future<void> createLeague(String leaguename, String competition) async {
    final String url = currServerPath + leaguesPath;

    UserInformation userInformation;
    userInformation = await currentSession.userRequests.fetchUserFromServer();

    print(url);

    final HttpClient httpClient = HttpClient();
    final HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(<String, String>{
      'name': leaguename,
      'competition': competition,
      'CreatorId': userInformation.id
    })));
    final HttpClientResponse response = await request.close();

    //String reply = await response.transform(utf8.decoder).join();
    httpClient.close();

    leaguesAreCached = false;
    leaguesAreLoading = false;
    notifyListeners();

    return response.statusCode;
  }

  void addLeague(League league) {
    print('adding a league');
    leagues.add(league);

    //call createLeague()

    notifyListeners(); // unecessary in case we called fetchLeaguesFromServer() instead
  }

  List<League> getLeagues() {
    if (leaguesAreCached) {
      return leagues;
    } else {
      if (leaguesAreLoading == false) {
        fetchLeaguesFromServer();
      }
      return <League>[];
    }
  }

  void deleteCachedLeagues() {
    leagues.clear();
    leaguesAreCached = false;
    notifyListeners();
    print('deleting cached leagues');
  }

  Future<void> fetchLeaguesFromServer() async {
    leagues.clear();
    leaguesAreLoading = true;

    final String url = currServerPath + leaguesPath;

    final http.Response response = await http.get(Uri.parse(url),
        headers: <String, String>{'accept': 'application/json'});

    final dynamic dataToJson = json.decode(response.body);
    final List<LeagueMember> leagueMembers = <LeagueMember>[];

    for (int i = 0; i < dataToJson.length; i++) {
      leagueMembers.clear();
      final http.Response responseMembers = await http.get(
          Uri.parse(url + '/' + dataToJson[i]['id'].toString() + '/users'),
          headers: <String, String>{'accept': 'application/json'});
      final dynamic dataToJsonMembers = json.decode(responseMembers.body);

      for (int j = 0; j < dataToJsonMembers.length; j++) {
        leagueMembers.add(LeagueMember(
            dataToJsonMembers[j]['email'], dataToJsonMembers[j]['points']));
      }

      leagues.add(League(
          leagueId: dataToJson[i]['id'],
          leagueName: dataToJson[i]['name'],
          leagueFounder: dataToJson[i]['CreatorId'],
          competition: dataToJson[i]['competition'],
          members: leagueMembers));
    }

    leaguesAreLoading = false;
    leaguesAreCached = true;

    Timer(const Duration(minutes: 5), () {
      deleteCachedLeagues();
    });

    notifyListeners();
  }

  Future<void> getNbaTeams() async {
    teamjson.clear();
    final http.Response response = await http.get(Uri.encodeFull(nbateams),
        headers: <String, String>{'Ocp-Apim-Subscription-Key': nbaKey});

    print(response.body);
    final dynamic dataToJson = json.decode(response.body);
    for (int i = 0; i < dataToJson.length; i++) {
      teamjson.add(TeamInfo(dataToJson[i]['City'], dataToJson[i]['Name'],
          dataToJson[i]['WikipediaLogoUrl'], dataToJson[i]['TeamID']));
    }
  }

  void getGamesByWeek() async {
    games.clear();
    await getNbaTeams();
    DateTime date = DateTime.now();
    String dateS;

    for (int i = 0; i < 7; i++) {
      dateS = date.year.toString() +
          '-' +
          date.month.toString() +
          '-' +
          date.day.toString();

      await getGamesByDate(dateS);

      date = date.add(const Duration(days: 1));
    }

    gamesAreCached = true;
    gamesAreLoading = false;
    notifyListeners();

    Timer(const Duration(minutes: 5), () {
      deleteCachedGames();
    });

    printGames();
  }

  Future<String> getGamesByDate(String date) async {
    final http.Response response = await http.get(
        Uri.encodeFull(gamesbydate + '/' + date),
        headers: <String, String>{'Ocp-Apim-Subscription-Key': nbaKey});

    final dynamic dataToJson = json.decode(response.body);

    if (dataToJson == null) return 'Success';

    for (int i = 0; i < dataToJson.length; i++) {
      if (dataToJson[i]['Status'] == 'Scheduled' ||
          dataToJson[i]['Status'] == 'Scheduled' ||
          dataToJson[i]['Status'] == 'Final' ||
          dataToJson[i]['Status'] == 'F/OT') {
        // ongoing---ver
        data.add(teamName(dataToJson[i]['HomeTeamID']) +
            ' VS ' +
            teamName(dataToJson[i]['AwayTeamID']));
        games.add(GameInfo(
            dataToJson[i]['GameID'],
            getTeamInfo(dataToJson[i]['HomeTeamID']),
            getTeamInfo(dataToJson[i]['AwayTeamID']),
            dataToJson[i]['HomeTeamScore'],
            dataToJson[i]['AwayTeamScore'],
            dataToJson[i]['DateTime'],
            dataToJson[i]['TimeRemainingMinutes'],
            null));
      }
    }

    return 'Success';
  }

  Future<void> getLastWeekGames() async {
    games = <GameInfo>[];
    await getNbaTeams();
    DateTime date = DateTime.now();
    String dateS;

    for (int i = 0; i < 3; i++) {
      date = date.subtract(const Duration(days: 1));
      dateS = date.year.toString() +
          '-' +
          date.month.toString() +
          '-' +
          date.day.toString();

      await getGamesByDate(dateS);
    }
    printGames();
  }

  Future<String> getCurrentNbaSeason() async {
    final http.Response response = await http.get(Uri.encodeFull(urlnflseason),
        headers: <String, String>{'Ocp-Apim-Subscription-Key': nflKey});
    print('Current Season is: ' + response.body);
    nbaseason = response.body;
    return 'Success';
  }

  Future<String> getnbaweekSchedule() async {
    await getCurrentNbaSeason();
    final http.Response response = await http.get(
        Uri.encodeFull(urlnbaschedule + '/' + nbaseason),
        headers: <String, String>{'Ocp-Apim-Subscription-Key': nbaKey});
    final dynamic dataToJson = json.decode(response.body);

    for (int i = 0; i < dataToJson.length; i++) {
      if (dataToJson[i]['Status'] == 'Scheduled') {
        data.add(
            dataToJson[i]['HomeTeam'] + ' VS ' + dataToJson[i]['AwayTeam']);
      }
    }
    return 'Success';
  }

  /////////////NFL////////////////

  Future<String> getCurrentSeason() async {
    final http.Response response = await http.get(Uri.encodeFull(urlnflseason),
        headers: <String, String>{'Ocp-Apim-Subscription-Key': nflKey});
    print('Current Season is: ' + response.body);
    nflseason = response.body;
    return 'Success';
  }

  Future<String> getCurrentWeek() async {
    final http.Response response = await http.get(
        //encode de URL
        Uri.encodeFull(urlweek),
        headers: <String, String>{'Ocp-Apim-Subscription-Key': nflKey});
    print('Current Week is: ' + response.body);
    week = response.body;
    return 'Success';
  }
/*
    Future<String> getnflweekSchedule() async {
      await getCurrentSeason();
      await getCurrentWeek();
      final http.Response response = await http.get(
          //encode de URL
          Uri.encodeFull(urlnflschedule + '/' + nflseason),
          headers: <String, String>{'Ocp-Apim-Subscription-Key': nflKey});
      final dynamic dataToJson = json.decode(response.body);

      for (int i = 0; i < dataToJson.length; i++) {
        if (dataToJson[i]['Week'].toString() == week &&
            dataToJson[i]['Status'] == 'Scheduled') {
          data.add(
              dataToJson[i]['HomeTeam'] + ' VS ' + dataToJson[i]['AwayTeam']);
          print(dataToJson[i]['HomeTeam'] +
              ' VS ' +
              dataToJson[i]['AwayTeam'] +
              '\n');
        }
      }
      return 'Success';
    }
  }*/

}
