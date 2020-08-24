import 'package:flutter/material.dart';
import 'package:ktg_client/main.dart';
import 'package:ktg_client/model/league.dart';
import 'package:ktg_client/model/league_invite.dart';
import 'package:shadow/shadow.dart';
import 'package:ktg_client/view/text_style.dart';

class LeagueInvites extends StatefulWidget {
  const LeagueInvites(this.leagueList);

  final List<League> leagueList;
  @override
  State<StatefulWidget> createState() => _LeagueInvitesState(leagueList);
}

class _LeagueInvitesState extends State<LeagueInvites> {
  _LeagueInvitesState(this.leagueList) {
    // print(currentSession.userRequests.userInformation.leagueInvites[0]);
  }

  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();

  final List<League> leagueList;
  //Test Team
  final List<Color> colors = <Color>[
    const Color(0xFF333388),
    const Color.fromRGBO(0, 179, 0, 1),
    const Color.fromRGBO(255, 51, 0, 1),
    const Color.fromRGBO(66, 66, 66, 1)
  ];

  void _deleteElement(int index) {
    setState(() {
      leagueList.removeAt(index);
    });
  }

  Future<List<LeagueInvite>> leagueInvites;

  @override
  void initState() {
    super.initState();
    leagueInvites = currentSession.userRequests.getLeagueInvites();
  }

  @override
  Widget build(BuildContext context) {
    Widget display;
    final Widget listdisplay = Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder<List<LeagueInvite>>(
                future: leagueInvites,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> projectSnap) {
                  if (projectSnap.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: projectSnap.data.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Shadow(
                              opacity: 0.5,
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Card(
                                        margin: const EdgeInsets.all(15.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            color:
                                                colors[index % colors.length],
                                          ),
                                          padding: const EdgeInsets.only(
                                              top: 15.0, bottom: 15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                        projectSnap.data[index]
                                                            .leagueName,
                                                        maxLines: 1,
                                                        style: Style
                                                            .joinleaguetitleStyle,
                                                        textAlign:
                                                            TextAlign.center,
                                                            ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              bottom: 5,
                                                              left: 30),
                                                      child: Separator(),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 30),
                                                      child: Text((() {
                                                        final String
                                                            tempstring =
                                                            projectSnap.data[index]
                                                                .membersCount
                                                                .length
                                                                .toString();
                                                        if (projectSnap.data[index]
                                                                .membersCount
                                                                .length ==
                                                            1) {
                                                          return tempstring +
                                                              ' jogador';
                                                        } else {
                                                          return tempstring +
                                                              ' jogadores';
                                                        }
                                                      })(),
                                                          maxLines: 1,
                                                          style: Style
                                                              .joinleagueplayernumberStyle,
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 5.0,
                                                              left: 5.0),
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxHeight: 40),
                                                      child: ButonNo(
                                                          leagueList,
                                                          index,
                                                          _deleteElement),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 5.0,
                                                              left: 5.0),
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxHeight: 40),
                                                      child: ButonYes(
                                                          leagueList,
                                                          index,
                                                          _deleteElement),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ))
                                  ]));
                        });
                  } else {
                    return Container();
                  }
                })));
    if (leagueList.isEmpty) {
      display = Center(
          child: Text('You have no league invites',
              style: Style.playerprofilename));
    } else {
      display = listdisplay;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('League Invites'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: display);
  }
}

class Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        height: 3.0,
        width: 150.0,
        color: const Color(0xff00c6ff));
  }
}

class ButonYes extends StatelessWidget {
  const ButonYes(this.leagueList, this.index, this.deleteElement);
  final List<League> leagueList;
  final int index;
  final Function deleteElement;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16.0),
                image:const DecorationImage(
                    image:  AssetImage('assets/yes.png'),
                    fit: BoxFit.cover) // button text
                )),
        onTap: () {
          final String leaguename = leagueList[index].leagueName;
          deleteElement(index);
          currentSession.userRequests.refuseAcceptLeagueInvite(2, 'true');
          final SnackBar snackBar = SnackBar(
            content: Text('You joined ' + leaguename),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the Scaffold in the widget tree and use
          // it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
          print('you clicked yes');
        });
  }
}

class ButonNo extends StatelessWidget {
  const ButonNo(this.leagueList, this.index, this.deleteElement);
  final List<League> leagueList;
  final int index;
  final Function deleteElement;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16.0),
                image:const DecorationImage(
                    image:  AssetImage('assets/no.png'),
                    fit: BoxFit.cover) // button text
                )),
        onTap: () {
          final String leaguename = leagueList[index].leagueName;
          deleteElement(index);
          currentSession.userRequests.refuseAcceptLeagueInvite(2, 'false');
          final SnackBar snackBar = SnackBar(
            content: Text('Refused invite to ' + leaguename),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the Scaffold in the widget tree and use
          // it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
          print('you clicked no');
        });
  }
}
