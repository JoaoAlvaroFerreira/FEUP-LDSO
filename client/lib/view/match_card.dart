import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ktg_client/controller/api_handler.dart';
import 'package:ktg_client/controller/user_requests.dart';
import 'package:ktg_client/env_variables.dart';
import 'package:ktg_client/main.dart';
import 'package:ktg_client/model/game_info.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ktg_client/model/league.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

import 'league_card.dart';

class MatchCard extends StatelessWidget {
  const MatchCard(
      {this.horizontal,
      this.gameInformation,
      this.isShimmered,
      this.showButton,
      this.leagueInformation});
  final bool showButton;
  final bool isShimmered;
  final GameInfo gameInformation;
  final bool horizontal;
  final League leagueInformation;

  @override
  Widget build(BuildContext context) {
    final Color teamLogocardColorBeforeLoad = Colors.blueGrey[300];
    final Color cardBackGroundColor = Theme.of(context).primaryColor;
    final Color textColor = cardBackGroundColor;
    final Color shimmerEffectColor = Colors.white;

    Widget homeTeamLogo;
    Widget homeTeamNameWidget;

    Widget awayTeamLogo;
    Widget awayTeamNameWidget;
    Widget dateWidget;
    Widget stadiumWidget;

    UserInformation userInformation;

    if (isShimmered) {
      homeTeamLogo = Shimmer.fromColors(
          baseColor: teamLogocardColorBeforeLoad,
          highlightColor: shimmerEffectColor,
          child: Container(
            width: 92.0,
            height: 92.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ));
      awayTeamLogo = Shimmer.fromColors(
          baseColor: teamLogocardColorBeforeLoad,
          highlightColor: shimmerEffectColor,
          child: Container(
            width: 92.0,
            height: 92.0,
            decoration: BoxDecoration(
              color: Colors.purple[100],
              shape: BoxShape.circle,
            ),
          ));
      homeTeamNameWidget = Shimmer.fromColors(
          enabled: isShimmered,
          baseColor: textColor,
          highlightColor: Colors.white,
          child: Container(
              margin: const EdgeInsets.all(20.0),
              child: Text(
                'Loading..',
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
              )));
      awayTeamNameWidget = Shimmer.fromColors(
          enabled: isShimmered,
          baseColor: textColor,
          highlightColor: Colors.white,
          child: Container(
              margin: const EdgeInsets.all(20.0),
              child: Text(
                'Loading..',
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
              )));
      dateWidget = Shimmer.fromColors(
          enabled: isShimmered,
          baseColor: textColor,
          highlightColor: Colors.white,
          child: Container(
              margin: const EdgeInsets.only(top: 55.0),
              child: Text('Loading..',
                  style: Theme.of(context).textTheme.body1,
                  textAlign: TextAlign.center)));

      stadiumWidget = Shimmer.fromColors(
          enabled: isShimmered,
          baseColor: textColor,
          highlightColor: Colors.white,
          child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2),
              child: Text('Loading..',
                  style: Theme.of(context).textTheme.body1,
                  textAlign: TextAlign.center),
              margin: const EdgeInsets.only(top: 10.0, bottom: 10.0)));
    } else {
      if (gameInformation.hometeam.getLogo() != 'test') {
        homeTeamLogo = SvgPicture.network(
          gameInformation.hometeam.getLogo(),
          placeholderBuilder: (BuildContext context) =>
              const CircularProgressIndicator(),
          height: 92.0,
          width: 92.0,
        );

        awayTeamLogo = SvgPicture.network(
          gameInformation.awayteam.getLogo(),
          placeholderBuilder: (BuildContext context) =>
              const CircularProgressIndicator(),
          height: 92.0,
          width: 92.0,
        );
      }

      homeTeamNameWidget = Container(
          margin: const EdgeInsets.all(20.0),
          child: Text(
            gameInformation.hometeam.getName(),
            style: Theme.of(context).textTheme.title,
            textAlign: TextAlign.center,
          ));
      awayTeamNameWidget = Container(
          margin: const EdgeInsets.all(20.0),
          child: Text(
            gameInformation.awayteam.getName(),
            style: Theme.of(context).textTheme.title,
            textAlign: TextAlign.center,
          ));

      dateWidget = Container(
          margin: const EdgeInsets.only(top: 55.0),
          child: Text(gameInformation.date,
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.center));

      stadiumWidget = Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
          child: Text('Capital One Arena',
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.center),
          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0));
    }
    final Widget matchThumbnail = Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
            flex: 2,
            child: Container(
                margin:
                    const EdgeInsets.only(top: 20.0, left: 10.0, bottom: 20.0),
                child: homeTeamLogo)),
        Expanded(flex: 1, child: dateWidget),
        Expanded(
            flex: 2,
            child: Container(
                margin:
                    const EdgeInsets.only(top: 20.0, left: 10.0, bottom: 20.0),
                child: awayTeamLogo))
      ],
    ));

    final Widget matchCardContent = Container(
      padding: const EdgeInsets.only(top: 20.0),
      constraints: const BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(flex: 2, child: homeTeamNameWidget),
              Expanded(
                  flex: 1,
                  child: Container(
                      margin: const EdgeInsets.all(20.0),
                      child: Text(
                        'VS',
                        style: Theme.of(context).textTheme.title,
                        textAlign: TextAlign.center,
                      ))),
              Expanded(flex: 2, child: awayTeamNameWidget)
            ],
          ),
          Separator(),
          stadiumWidget,
          Visibility(
            visible: showButton,
            child: DialogButton(
                color: Colors.purple,
                width: 200,
                child: const Text('Add match to a league'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text('Select a league please'),
                            content: Container(
                              width: double.maxFinite,
                              child: Consumer<ApiHandler>(
                                builder: (BuildContext context,
                                        ApiHandler apiHandler, Widget child) =>
                                    ListView.builder(
                                  itemCount: apiHandler.getLeagues().length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      child: LeagueCard(
                                        leagueInformation:
                                            apiHandler.getLeagues()[index],
                                        isShimmered:
                                            !apiHandler.leaguesAreCached,
                                      ),
                                      onTap: () async {
                                        String msg = '';

                                        final Map<String, String> headers =
                                            <String, String>{
                                          'Content-type': 'application/json'
                                        };

                                        userInformation = await currentSession
                                            .userRequests
                                            .fetchUserFromServer();

                                        final String getUsersInLeagueURL =
                                            currServerPath +
                                                leaguesPath +
                                                '/' +
                                                apiHandler
                                                    .getLeagues()[index]
                                                    .leagueId
                                                    .toString() +
                                                '/users';

                                        final ProgressDialog pr =
                                            ProgressDialog(context);
                                        pr.show();

                                        http.Response response = await http.get(
                                            Uri.parse(getUsersInLeagueURL),
                                            headers: headers);

                                        dynamic dataToJson =
                                            json.decode(response.body);
                                        bool isMember = false;
                                        for (int i = 0;
                                            i < dataToJson.length;
                                            i++) {
                                          if (dataToJson[i]['id'] ==
                                              userInformation.id) {
                                            isMember = true;
                                            break;
                                          }
                                        }

                                        if (isMember == false) {
                                          msg =
                                              'you are not a member of this league';
                                        } else {
                                          //checking if match is already in the league
                                          final String getMatchesInLeagueURL =
                                              currServerPath +
                                                  leaguesPath +
                                                  '/' +
                                                  apiHandler
                                                      .getLeagues()[index]
                                                      .leagueId
                                                      .toString() +
                                                  '/games';

                                          response = await http.get(
                                              Uri.parse(getMatchesInLeagueURL),
                                              headers: headers);

                                          dataToJson =
                                              json.decode(response.body);

                                          print('Status Code:' +
                                              response.statusCode.toString());

                                          bool matchExistInLeague = false;

                                          for (int i = 0;
                                              i < dataToJson.length;
                                              i++) {
                                            if (dataToJson[i]['GameID'] ==
                                                gameInformation.gameId) {
                                              print('game id:' +
                                                  dataToJson[i]['GameID']
                                                      .toString() +
                                                  'already exists in league:' +
                                                  apiHandler
                                                      .getLeagues()[index]
                                                      .leagueName);
                                              matchExistInLeague = true;
                                              break;
                                            }
                                          }

                                          // adding a match to a league if it does not exist already
                                          if (matchExistInLeague == false) {
                                            final String addMatchURL =
                                                currServerPath +
                                                    'api/v1/sports/nba/addGame';

                                            print('final min:' + addMatchURL);
                                            final String
                                                addMatchToLeagueRequest =
                                                '{"UserId": "' +
                                                    userInformation.id +
                                                    '","GameId":' +
                                                    gameInformation.gameId
                                                        .toString() +
                                                    ',"LeagueId":' +
                                                    apiHandler
                                                        .getLeagues()[index]
                                                        .leagueId
                                                        .toString() +
                                                    '}';

                                            // make POST request
                                            response = await http.post(
                                                addMatchURL,
                                                headers: headers,
                                                body: addMatchToLeagueRequest);

                                            print('Status Code:' +
                                                response.statusCode.toString());
                                            print(response.body);
                                            msg =
                                                'match has been addded to league (' +
                                                    apiHandler
                                                        .getLeagues()[index]
                                                        .leagueName +
                                                    ')';
                                          } else {
                                            msg =
                                                'Match already exist in league';
                                          }
                                        }

                                        pr.hide();

                                        Alert(
                                            context: context,
                                            title: msg,
                                            buttons: <DialogButton>[
                                              DialogButton(
                                                child: const Text('Okay'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ]).show();
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              // usually buttons at the bottom of the dialog
                              FlatButton(
                                child: const Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ]);
                      });
                }),
          )
        ],
      ),
    );

    final Widget matchCard = Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 80.0),
      height: 230,
      child: matchCardContent,
      decoration: BoxDecoration(
        color: cardBackGroundColor, //Color(0xFF333366),
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
    );

    return Container(
      child: Stack(
        children: <Widget>[
          matchCard,
          matchThumbnail,
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
