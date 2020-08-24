import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ktg_client/controller/user_requests.dart';
import 'package:ktg_client/env_variables.dart';
import 'package:http/http.dart' as http;
import 'package:ktg_client/main.dart';
import 'package:ktg_client/model/game_info.dart';
import 'package:ktg_client/model/league.dart';
import 'package:ktg_client/view/text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TestGame extends StatefulWidget {
  const TestGame(this.gameInformation, this.leagueInformation);
  final GameInfo gameInformation;
  final League leagueInformation;
  @override
  _TestGameState createState() =>
      _TestGameState(gameInformation, leagueInformation);
}

class _TestGameState extends State<TestGame> {
  _TestGameState(this.gameInformation, this.leagueInformation);

  final TextEditingController homeController = TextEditingController();
  final TextEditingController awayController = TextEditingController();

  final GameInfo gameInformation;
  final League leagueInformation;
  @override
  Widget build(BuildContext context) {
    print('this is date variable:' + gameInformation.date);
    print('this is date time variable:' + gameInformation.datetime);
    final ProgressDialog progressBar =
        ProgressDialog(context, type: ProgressDialogType.Normal);
    UserInformation userInformation;

    progressBar.style(message: 'Placing Bet...');

    final Widget bet = Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2, color: Colors.blueAccent),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const SizedBox(width: 50.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: homeController,
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 4.0),
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      'Home Team',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 80.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: awayController,
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 4.0),
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      'Away Team',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 50.0)
            ],
          ),
          const SizedBox(height: 10.0),
          MaterialButton(
            color: Colors.blue[300],
            textColor: Colors.white,
            child: const Text('Place Bet'),
            onPressed: () async {
              //final ApiHandler apiHandler = Provider.of<ApiHandler>(context);
              userInformation =
                  await currentSession.userRequests.fetchUserFromServer();

              print('home score:' + homeController.text);
              print('away score:' + awayController.text);
              if (homeController.text == '' || awayController.text == '') {
                Alert(
                    context: context,
                    title:
                        'please specifiy both home team and away team scores',
                    buttons: <DialogButton>[
                      DialogButton(
                        child: const Text('okay'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ]).show();
              } else {
                // if userid exists in bet table with the same gameID then tell user that he already has made a bet with that match

                progressBar.show();
                final String betsURL = currServerPath + 'api/v1/bets';

                http.Response response;
                dynamic dataToJson;

                final String getMatchesInLeagueURL = currServerPath +
                    leaguesPath +
                    '/' +
                    leagueInformation.leagueId.toString() +
                    '/games';

                response = await http.get(Uri.parse(getMatchesInLeagueURL),
                    headers: <String, String>{
                      'Content-type': 'application/json'
                    });

                dataToJson = json.decode(response.body);
                int idOfMatchInsideLeague;
                for (int i = 0; i < dataToJson.length; i++) {
                  if (dataToJson[i]['GameID'] == gameInformation.gameId) {
                    idOfMatchInsideLeague = dataToJson[i]['id'];
                    break;
                  }
                }

                response = await http.get(Uri.parse(betsURL),
                    headers: <String, String>{
                      'Content-type': 'application/json'
                    });
                dataToJson = json.decode(response.body);

                bool betAlreadyMade = false;
                for (int i = 0; i < dataToJson.length; i++) {
                  if (dataToJson[i]['GameId'] == idOfMatchInsideLeague &&
                      dataToJson[i]['UserId'] == userInformation.id &&
                      dataToJson[i]['LeagueId'] == leagueInformation.leagueId) {
                    betAlreadyMade = true;
                    break;
                  }
                }

                if (betAlreadyMade) {
                  progressBar.hide();
                  Alert(
                          context: context,
                          title: 'OOPs! You already bet on this match')
                      .show();
                } else {
                  final Map<String, dynamic> activityData = <String, dynamic>{
                    'points': 50,
                    'homeTeamScore': homeController.text,
                    'awayTeamScore': awayController.text,
                    'UserId': userInformation.id,
                    'LeagueId': leagueInformation.leagueId,
                    'GameId': idOfMatchInsideLeague,
                  };

                  //  print('json:' + jsonEncode(activityData));

                  print('url:' + betsURL);
                  bool error = true;

                  response = await http.post(betsURL,
                      headers: <String, String>{
                        'Content-type': 'application/json'
                      },
                      body: jsonEncode(activityData));
                  //print('Response status: ${response.statusCode}');

                  progressBar.hide();

                  //  print('status code:' + response.statusCode.toString());
                  if (response.statusCode == 201) {
                    error = false;
                  }

                  if (error == false) {
                    Alert(
                        context: context,
                        title: 'bet has been added',
                        buttons: <DialogButton>[
                          DialogButton(
                            child: const Text('okay'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ]).show();
                  } else {
                    Alert(
                        context: context,
                        title: 'Ooops..Something went wrong',
                        buttons: <DialogButton>[
                          DialogButton(
                            child: const Text('close'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ]).show();
                  }
                }
              }
            },
          ),
        ],
      ),
    );

    return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Match Details'),
        ),
        body: Container(
            child: ListView(
          children: <Widget>[
            Container(
              child: Stack(children: <Widget>[
                _getBackground(),
                _getGradient(),
                _getContent(gameInformation)
              ]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: bet,
            )
          ],
        )));
  }
}

class MatchSummary extends StatelessWidget {
  const MatchSummary(this.gameInformation);
  const MatchSummary.vertical(this.gameInformation);
  final GameInfo gameInformation;
  @override
  Widget build(BuildContext context) {
    final Widget planetThumbnail = Container(
        margin: const EdgeInsets.only(top: 195),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                    margin: const EdgeInsets.only(
                        top: 20.0, left: 10.0, bottom: 20.0),
                    child: SvgPicture.network(
                      gameInformation.hometeam.getLogo(),
                      placeholderBuilder: (BuildContext context) =>
                          const CircularProgressIndicator(),
                      height: 92.0,
                      width: 92.0,
                    ))),
            Expanded(
                flex: 1,
                child: Container(
                    margin: const EdgeInsets.only(top: 55.0),
                    child: Text(
                        gameInformation.date +
                            '(' +
                            gameInformation.datetime +
                            ')',
                        style: Style.commonTextStyle,
                        textAlign: TextAlign.center))),
            Expanded(
                flex: 2,
                child: Container(
                    margin: const EdgeInsets.only(
                        top: 20.0, right: 10.0, bottom: 20.0),
                    child: SvgPicture.network(
                      gameInformation.awayteam.getLogo(),
                      placeholderBuilder: (BuildContext context) =>
                          const CircularProgressIndicator(),
                      height: 92.0,
                      width: 92.0,
                    )))
          ],
        ));

    final Widget planetCardContent = Container(
      padding: const EdgeInsets.only(top: 20.0),
      constraints: const BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      margin: const EdgeInsets.all(20.0),
                      child: AutoSizeText(
                        gameInformation.hometeam.getName(),
                        style: Style.titleTextStyleggameinfo,
                        minFontSize: 15,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ))),
              Expanded(
                  flex: 1,
                  child: Container(
                      margin: const EdgeInsets.all(20.0),
                      child: Text(
                        'VS',
                        style: Style.titleTextStyle,
                        textAlign: TextAlign.center,
                      ))),
              Expanded(
                  flex: 2,
                  child: Container(
                      margin: const EdgeInsets.all(20.0),
                      child: AutoSizeText(
                        gameInformation.awayteam.getName(),
                        style: Style.titleTextStyleggameinfo,
                        minFontSize: 15,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      )))
            ],
          ),
          Separator(),
          Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2),
              child: Text('Capital One Arena',
                  style: Style.commonTextStyle, textAlign: TextAlign.center),
              margin: const EdgeInsets.only(top: 10.0, bottom: 10.0)),
        ],
      ),
    );

    final Container planetCard = Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 270.0),
      child: planetCardContent,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.blueGrey,
            blurRadius: 20.0,
            spreadRadius: 5.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return Container(
      child: Stack(
        children: <Widget>[
          planetCard,
          planetThumbnail,
        ],
      ),
    );
  }
}

class Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        height: 2.0,
        width: 200.0,
        color: const Color(0xff00c6ff));
  }
}

Container _getBackground() {
  return Container(
    child: Image(
        image: const AssetImage('assets/nbabackground.jpg'),
        fit: BoxFit.fill,
        color: Colors.blue,
        colorBlendMode: BlendMode.color),
  );
}

Container _getGradient() {
  return Container(
    margin: const EdgeInsets.only(top: 200.0),
    height: 110.0,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[Color(0x00000000), Color(0xFFFFFFFF)],
        stops: <double>[0.0, 0.9],
        begin: FractionalOffset(0.0, 0.0),
        end: FractionalOffset(0.0, 1.0),
      ),
    ),
  );
}

Container _getContent(GameInfo gameInformation) {
  return Container(
    margin: const EdgeInsets.only(left: 25, right: 25),
    height: 430,
    child: MatchSummary(gameInformation),
  );
}
