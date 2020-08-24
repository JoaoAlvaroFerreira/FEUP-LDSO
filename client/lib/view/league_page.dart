import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ktg_client/controller/api_handler.dart';
import 'package:ktg_client/controller/user_requests.dart';
import 'package:ktg_client/env_variables.dart';
import 'package:ktg_client/main.dart';
import 'package:ktg_client/view/game_info.dart';
import 'package:ktg_client/view/match_card.dart';
import 'package:ktg_client/view/text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ktg_client/model/league.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;

class LeaguePage extends StatefulWidget {
  const LeaguePage(this.leagueinfo);
  final League leagueinfo;

  @override
  _LeaguePageState createState() => _LeaguePageState(leagueinfo);
}

class _LeaguePageState extends State<LeaguePage>
    with SingleTickerProviderStateMixin {
  _LeaguePageState(this.leagueinfo);

  TabController controller;
  final League leagueinfo;
  bool isMember = false;
  bool matchesInsideLeagueAreFetched;
  final List<int> matchesIdsInLeague = <int>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    matchesInsideLeagueAreFetched = false;
    controller = TabController(vsync: this, length: 2);
    _checkIfUserIsAMember().then((dynamic result) {
      setState(() {});
    });

    _getMatchesInLeague().then((dynamic onValue) {
      setState(() {
        matchesInsideLeagueAreFetched = true;
      });
    });
  }

  Future<void> _checkIfUserIsAMember() async {
    UserInformation userInformation;
    userInformation = await currentSession.userRequests.fetchUserFromServer();

    //checking if user is a member of the league
    final String getUsersInLeagueURL = currServerPath +
        leaguesPath +
        '/' +
        leagueinfo.leagueId.toString() +
        '/users';

    final http.Response response = await http.get(
        Uri.parse(getUsersInLeagueURL),
        headers: <String, String>{'Content-type': 'application/json'});

    final dynamic dataToJson = json.decode(response.body);

    for (int i = 0; i < dataToJson.length; i++) {
      if (dataToJson[i]['id'] == userInformation.id) {
        isMember = true;
        break;
      }
    }
  }

  Future<void> _getMatchesInLeague() async {
    print('league id is :' + leagueinfo.leagueId.toString());

    final String getMatchesInLeagueURL = currServerPath +
        leaguesPath +
        '/' +
        leagueinfo.leagueId.toString() +
        '/games';
    print('finalll:' + getMatchesInLeagueURL);
    final http.Response response = await http.get(
        Uri.parse(getMatchesInLeagueURL),
        headers: <String, String>{'Content-type': 'application/json'});

    final dynamic dataToJson = json.decode(response.body);

    print('Status Code:' + response.statusCode.toString());

    for (int i = 0; i < dataToJson.length; i++) {
      matchesIdsInLeague.add(dataToJson[i]['GameID']);
      print(dataToJson[i]['GameID']);
    }

    print(matchesIdsInLeague);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            alignment: const Alignment(0.0, 0.0),
            //color: Color.fromRGBO(0, 0, 255, 1),
            child: _getContent(context)));
  }

  Widget _getContent(BuildContext context) {
    bool matchesExist = false;

    final ApiHandler apiHandler = Provider.of<ApiHandler>(context);

    final List<Widget> matchesList = <Widget>[];

    if (apiHandler.gamesAreLoading == false) {
      print('here');
      final int length = apiHandler.getGames().length;
      for (int i = 0; i < length; i++) {
        if (matchesIdsInLeague.contains(apiHandler.getGames()[i].gameId) ==
            true) {
          matchesExist = true;

          matchesList.add(InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return TestGame(apiHandler.getGames()[i], leagueinfo);
              }));
            },
            child: MatchCard(
              gameInformation: apiHandler.getGames()[i],
              showButton: !isMember,
              isShimmered: !apiHandler.gamesAreCached,
            ),
          ));
        }
      }
    }

    return Column(
      children: <Widget>[
        LeagueCardDetails(leagueinfo, isMember),
        TabBar(
          labelColor: Colors.black,
          controller: controller,
          tabs: const <Widget>[
            Tab(
              text: 'players',
            ),
            Tab(
              text: 'matches',
            )
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: <Widget>[
              PlayerTable(leagueinfo.members),
              Visibility(
                visible:
                    apiHandler.gamesAreCached && matchesInsideLeagueAreFetched,
                child: Visibility(
                  visible: matchesExist,
                  child: ListView(
                    children: matchesList,
                  ),
                  replacement: const Center(
                      child: Text(
                    'OOPs!! There are no matches in this league..',
                    style: TextStyle(color: Colors.black),
                  )),
                ),
                replacement: SpinKitHourGlass(
                  color: Theme.of(context).primaryColor,
                  size: 100,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        height: 2.0,
        width: 100.0,
        color: const Color(0xff00c6ff));
  }
}

class LeagueCardDetails extends StatelessWidget {
  const LeagueCardDetails(this.leagueinfo, this.isMember);

  final League leagueinfo;
  final bool isMember;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 283,
      margin: const EdgeInsets.only(bottom: 5.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(5.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: const Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 21.0, bottom: 21.0),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(90.0),
                )),
            child: SvgPicture.network(
              'https://upload.wikimedia.org/wikipedia/commons/c/c6/Inkscape-small.svg',
              placeholderBuilder: (BuildContext context) =>
                  const CircularProgressIndicator(),
              height: 92.0,
              width: 92.0,
            ),
          ),
          Text(
            leagueinfo.leagueName,
            style: Style.titleTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Visibility(
            child: DialogButton(
                child: const Text('Join'),
                width: 100,
                onPressed: () {
                  // to change
                  print('you clicked yes');
                }),
            visible: !isMember,
          ),
          Visibility(
            visible: isMember,
            child: const Text('you are a member of this league'),
          )
        ],
      ),
    );
  }
}

class PlayerTable extends StatelessWidget {
  const PlayerTable(this.temp);
  final List<LeagueMember> temp;

  @override
  Widget build(BuildContext context) {
    print(temp.length);
    return Container(
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: temp.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                    Card(
                      child: Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: RichText(
                                text: TextSpan(
                                    text: temp[index].email,
                                    style:
                                        const TextStyle(color: Colors.black))),
                            flex: 4,
                          ),
                          Expanded(
                            child: RichText(
                                text: TextSpan(
                                    text: temp[index].points.toString(),
                                    style:
                                        const TextStyle(color: Colors.black))),
                            flex: 1,
                          ),
                        ],
                      )),
                    )
                  ]));
            }));
  }
}
