import 'package:flutter/material.dart';
import 'package:ktg_client/model/game_info.dart';
import 'package:ktg_client/view/match_card.dart';
import 'package:numberpicker/numberpicker.dart';

class MatchCardDetails extends StatefulWidget {
  const MatchCardDetails({this.gameInformation});
  final GameInfo gameInformation;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MatchCardDetailsState(gameInformation: gameInformation);
  }
}

class _MatchCardDetailsState extends State<MatchCardDetails> {
  _MatchCardDetailsState({this.gameInformation});

  int _currentValue1 = 0;
  int _currentValue2 = 0;

  GameInfo gameInformation;
  @override
  Widget build(BuildContext context) {
    final Widget bet = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: NumberPicker.integer(
              initialValue: _currentValue1,
              minValue: 0,
              maxValue: 100,
              onChanged: (num value) => setState(() => _currentValue1 = value)),
        ),
        Expanded(
          child: NumberPicker.integer(
              initialValue: _currentValue2,
              minValue: 0,
              maxValue: 100,
              onChanged: (num value) => setState(() => _currentValue2 = value)),
        )
      ],
    );

    return Scaffold(
        body: Container(
            child: ListView(
      children: <Widget>[
        Container(
          child: Stack(children: <Widget>[
            _getBackground(),
            _getGradient(),
            _getContent(gameInformation),
            //_getToolbar(context),
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
    child:const Image(
        image:  AssetImage('assets/nbabackground.jpg'), fit: BoxFit.fill),
  );
}

Container _getGradient() {
  return Container(
    margin: const EdgeInsets.only(top: 200.0),
    height: 110.0,
    decoration:const BoxDecoration(
      gradient: LinearGradient(
        colors:  <Color>[Color(0x00000000), Color(0xFFFFFFFF)],
        stops:  <double>[0.0, 0.9],
        begin:  FractionalOffset(0.0, 0.0),
        end:  FractionalOffset(0.0, 1.0),
      ),
    ),
  );
}

Container _getContent(GameInfo gameInformation) {
  return Container(
    margin: const EdgeInsets.only(left: 25, right: 25, top: 200),
    child: MatchCard(
      horizontal: false,
      gameInformation: gameInformation,
    ),
  );
}

/*Container _getToolbar(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    child: BackButton(color: Colors.white),
  );
}*/
