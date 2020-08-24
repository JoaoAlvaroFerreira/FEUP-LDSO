import 'package:ktg_client/main.dart';
import 'package:flutter/material.dart';
import 'package:ktg_client/view/league_invites.dart';
import 'package:ktg_client/presentation/costum_icons.dart';
import 'package:ktg_client/model/league.dart';
import 'package:ktg_client/model/team_info.dart';

import 'package:ktg_client/controller/user_requests.dart';
import 'package:ktg_client/view/text_style.dart';

class Profile extends StatefulWidget {
  @override
  State createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  ProfileState();

  Future<UserInformation> userInformation;

  @override
  void initState() {
    super.initState();
    userInformation = currentSession.userRequests.fetchUserFromServer();
  }

  int statusCode;
  TeamInfo team = TeamInfo(
      'Washington',
      'Wizards',
      'https://upload.wikimedia.org/wikipedia/en/0/02/Washington_Wizards_logo.svg',
      111);

  //Test League
  static final League templeague = League(
      leagueId: 1,
      leagueName: 'Liga Dos Amigos Test',
      leagueFounder: 'sda',
      competition: 'Nba',
      members: <LeagueMember>[
        LeagueMember('test@test.com', 3),
        LeagueMember('test@test2.com', 2)
      ]);

  //Test Array for widget
  final List<League> temp = <League>[
    League(
        leagueId: 1,
        leagueName: 'Liga Dos Amigos',
        leagueFounder: 'sda',
        competition: 'Nba',
        members: <LeagueMember>[LeagueMember('test@test.com', 3)]),
    templeague,
    templeague,
    templeague,
    templeague,
    templeague,
    templeague
  ];

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        ClipPath(
            child: Container(color: Colors.indigo.withOpacity(0.8)),
            clipper: GetClipper()),
        Container(
            child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 9),
          child: Align(
            alignment: const Alignment(0, 0),
            child: Column(
              children: <Widget>[
                Container(
                    width: 150,
                    height: 150,
                    child: FutureBuilder<UserInformation>(
                      future: userInformation,
                      builder: (BuildContext context,
                          AsyncSnapshot<UserInformation> snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                image: DecorationImage(
                                    image: NetworkImage(() {
                                      if (snapshot.data.photoUrl != null) {
                                        return snapshot.data.photoUrl;
                                      } else {
                                        return 'https://upload.wikimedia.org/wikipedia/en/d/dc/MichaelScott.png';
                                      }
                                    }()),
                                    fit: BoxFit.cover),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(75)),
                                boxShadow:const <BoxShadow>[
                                  BoxShadow(blurRadius: 7, color: Colors.black)
                                ]),
                          );
                        }
                        // By default, show a loading spinner.
                        return const CircularProgressIndicator();
                      },
                    )),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(top: 15, bottom: 2),
                          child: FutureBuilder<UserInformation>(
                            future: userInformation,
                            builder: (BuildContext context,
                                AsyncSnapshot<UserInformation> snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data.name,
                                    maxLines: 1,
                                    style: Style.playerprofilename,
                                    textAlign: TextAlign.center);
                              }
                              // By default, show a loading spinner.
                              return const CircularProgressIndicator();
                            },
                          )),
                      Container(
                          child: FutureBuilder<UserInformation>(
                        future: userInformation,
                        builder: (BuildContext context,
                            AsyncSnapshot<UserInformation> snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data.email,
                                maxLines: 1,
                                style: Style.playerprofilesubtitle,
                                textAlign: TextAlign.center);
                          }
                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        },
                      )),
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                const Icon(MyFlutterApp.league_icon,
                                    size: 25.0, color: Colors.indigo),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text('Number of leagues joined: ',
                                    maxLines: 1,
                                    style: Style.playerprofileboldsubtitle,
                                    textAlign: TextAlign.center),
                                Text('3',
                                    maxLines: 1,
                                    style: Style.playerprofilesubtitle,
                                    textAlign: TextAlign.center)
                              ],
                            )),
                            Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                const Icon(MyFlutterApp.friend_icon,
                                    size: 25.0, color: Colors.indigo),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text('Friends: ',
                                    maxLines: 1,
                                    style: Style.playerprofileboldsubtitle,
                                    textAlign: TextAlign.center),
                                Text('2',
                                    maxLines: 1,
                                    style: Style.playerprofilesubtitle,
                                    textAlign: TextAlign.center)
                              ],
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Separator(),
                InkWell(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue,
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
                      child: const Text('View League Invites'),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                        return LeagueInvites(temp);
                      }));
                    }),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue,
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
                    child: const Text('Sign Out'),
                  ),
                  onTap: currentSession.userRequests.handleSignOut,
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  /*    */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          color: const Color.fromRGBO(204, 229, 255, 1),
          child: _buildBody(),
        ));
  }
}

class Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 25.0),
        height: 2.0,
        width: 240.0,
        color: const Color(0xff00c6ff));
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0.0, size.height / 3);
    path.lineTo(size.width + 500, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
