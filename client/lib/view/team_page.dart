import 'package:flutter/material.dart';
import 'package:ktg_client/model/team_info.dart';
import 'package:ktg_client/model/player_info.dart';
import 'package:ktg_client/view/text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeamPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  TeamInfo team = TeamInfo(
      'Washington',
      'Wizards',
      'https://upload.wikimedia.org/wikipedia/en/0/02/Washington_Wizards_logo.svg',
      111);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            alignment: const Alignment(0.0, 0.0),
            child: _getContent(context)));
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

class TeamCard extends StatelessWidget {
  const TeamCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      margin: const EdgeInsets.only(bottom: 10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
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
              'https://upload.wikimedia.org/wikipedia/en/c/c4/Charlotte_Hornets_%282014%29.svg',
              placeholderBuilder: (BuildContext context) =>
                  const CircularProgressIndicator(),
              height: 92.0,
              width: 92.0,
            ),
          ),
          Text(
            'Washington Wizards',
            style: Style.titleTextStyle,
            textAlign: TextAlign.center,
          ),
          Container(
              margin: const EdgeInsets.only(top: 12.0, bottom: 5.0),
              child: Separator()),
          Container(
            margin: const EdgeInsets.only(bottom: 7.0),
            child: Text('Capital One Arena',
                style: Style.commonTextStyle, textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }
}

class PlayerTable extends StatelessWidget {
  PlayerTable();

  final List<PlayerInfo> temp = <PlayerInfo>[
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
    PlayerInfo('Steven Adams', 'SG', 21, 7),
  ];

  @override
  Widget build(BuildContext context) {
    print(temp.length);
    return Container(
        height: MediaQuery.of(context).size.height * 0.50,
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
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Expanded(
                                child: Text(temp[index].playerName),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text(temp[index].age.toString()),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text(temp[index].jersey.toString()),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text(temp[index].position),
                                flex: 2,
                              ),
                            ],
                          )),
                    )
                  ]));
            }));
  }
}

Container _getContent(BuildContext context) {
  return Container(
      //  padding: const EdgeInsets.only(left: 25, right: 25),
      height: double.infinity,
      child: Column(
        children: <Widget>[
          const TeamCard(),
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            padding: const EdgeInsets.only(top: 9.0, bottom: 9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Players',
                  style: Style.titleTextStyle,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          PlayerTable(),
        ],
      ));
}
