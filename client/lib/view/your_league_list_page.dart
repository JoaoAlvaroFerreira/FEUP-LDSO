import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:ktg_client/controller/api_handler.dart';
import 'package:ktg_client/view/league_card.dart';
import 'package:ktg_client/view/league_page.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'create_league_form.dart';

class YourLeagueListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ApiHandler apiHandler =
        Provider.of<ApiHandler>(context, listen: false);
    print('check3');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your List Page'),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (apiHandler.leaguesAreLoading == false) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text('Create League'),
                              content: const CreateLeagueForm(),
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
                  } else {
                    Alert(context: context, title: 'Please wait until all the leagues load', buttons: <DialogButton>[
                      DialogButton(
                        child: const Text('Okay'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ]).show();
                  }
                })
          ],
        ),
        body: Consumer<ApiHandler>(
            builder: (BuildContext context, ApiHandler apiHandler,
                    Widget child) =>
                Visibility(
                    visible: apiHandler.leaguesAreCached,
                    child: ListView.builder(
                      itemCount: apiHandler.getLeagues().length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          child: LeagueCard(
                            leagueInformation: apiHandler.getLeagues()[index],
                            isShimmered: !apiHandler.leaguesAreCached,
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                              return LeaguePage(apiHandler.getLeagues()[index]);
                            }));
                          },
                        );
                      },
                    ),
                    replacement: SpinKitHourGlass(
                      color: Theme.of(context).primaryColor,
                      size: 100,
                    ))));
  }
}
