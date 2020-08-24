import 'package:flutter/material.dart';
import 'package:ktg_client/controller/api_handler.dart';
import 'package:ktg_client/view/league_card.dart';
import 'package:provider/provider.dart';

class WorldLeagueListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('World List Page'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Consumer<ApiHandler>(
          builder:
              (BuildContext context, ApiHandler apiHandler, Widget child) =>
                  ListView.builder(
            itemCount: apiHandler.getLeagues().length,
            itemBuilder: (BuildContext context, int index) {
              return LeagueCard(
                leagueInformation: apiHandler.getLeagues()[index],
                isShimmered: !apiHandler.leaguesAreCached,
              );
            },
          ),
        ));
  }
}
