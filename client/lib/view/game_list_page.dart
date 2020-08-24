import 'package:flutter/material.dart';
import 'package:ktg_client/controller/api_handler.dart';
import 'package:ktg_client/view/match_card.dart';
import 'package:provider/provider.dart';

class GameListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Games Page'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Consumer<ApiHandler>(
          builder:
              (BuildContext context, ApiHandler apiHandler, Widget child) =>
                  ListView.builder(
            itemCount: apiHandler.getGames().length,
            itemBuilder: (BuildContext context, int index) {
              return MatchCard(
                gameInformation: apiHandler.getGames()[index],
                isShimmered: !apiHandler.gamesAreCached,
                showButton: !apiHandler.gamesAreLoading,
              );
            },
          ),
        ));
  }
}
