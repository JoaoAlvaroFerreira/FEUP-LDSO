import 'package:flutter/material.dart';
import 'package:ktg_client/model/league.dart';
import 'package:ktg_client/view/text_style.dart';

class LeagueCard extends StatelessWidget {
  const LeagueCard({this.horizontal, this.leagueInformation, this.isShimmered});
  final bool isShimmered;
  final League leagueInformation;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final Color cardBackGroundColor = Theme.of(context).primaryColor;
    //final Color textColor = cardBackGroundColor;
    //final Color shimmerEffectColor = Colors.white;

    final Widget leagueCardContent = Container(
      padding: const EdgeInsets.only(top: 10.0),
      constraints: const BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Text(leagueInformation.leagueName,
                          maxLines: 1,
                          style: Style.joinleaguetitleStyle,
                          textAlign: TextAlign.center),
                      Text(leagueInformation.competition,
                          maxLines: 1,
                          style: Style.joinleagueplayernumberStyle,
                          textAlign: TextAlign.center),
                      Separator(),
                      Text((() {
                        final String tempstring =
                            leagueInformation.members.length.toString();
                        if (leagueInformation.members.length == 1) {
                          return tempstring + ' jogador';
                        } else {
                          return tempstring + ' jogadores';
                        }
                      })(),
                          maxLines: 1,
                          style: Style.joinleagueplayernumberStyle,
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final Widget leagueCard = Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 30.0),
      height: 140,
      child: leagueCardContent,
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

    return leagueCard;
  }
}

class Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        height: 3.0,
        width: 80.0,
        color: const Color(0xff00c6ff));
  }
}
