














import 'package:ktg_client/view/login_page.dart';
import 'package:ktg_client/view/profile.dart';
import 'package:ktg_client/view/root_page.dart';
import 'package:ktg_client/view/game_list_page.dart';
import 'package:ktg_client/view/world_league_list_page.dart';
import 'package:ktg_client/view/your_league_list_page.dart';
import 'package:ktg_client/view/game_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TabItem {
  feed,
  games,
  world_league,
  your_leagues,
  profile,
  login_screen,
  game_page
}

String tabItemName(TabItem tabItem) {
  switch (tabItem) {
    case TabItem.feed:
      return 'feed';
    case TabItem.games:
      return 'games';
    case TabItem.world_league:
      return 'world_league';
    case TabItem.your_leagues:
      return 'your_leagues';
    case TabItem.profile:
      return 'profile';
    case TabItem.login_screen:
      return 'loginpage';
    case TabItem.game_page:
      return 'game_page';
    default:
      return null;
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TabItem currentItem = TabItem.feed;

  void _onSelectTab(int index) {
    switch (index) {
      case 0:
        _updateCurrentItem(TabItem.feed);
        break;
      case 1:
        _updateCurrentItem(TabItem.games);
        break;
      case 2:
        _updateCurrentItem(TabItem.world_league);
        break;
      case 3:
        _updateCurrentItem(TabItem.your_leagues);
        break;
      case 4:
        _updateCurrentItem(TabItem.profile);
        break;
      case 5:
        _updateCurrentItem(TabItem.login_screen);
        break;
      case 6:
        _updateCurrentItem(TabItem.game_page);
        break;
    }
  }

  void _updateCurrentItem(TabItem item) {
    setState(() {
      currentItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    switch (currentItem) {
      case TabItem.feed:
        return RootPage();
      case TabItem.games:
        return GameListPage();
      case TabItem.world_league:
        return WorldLeagueListPage();
      case TabItem.your_leagues:
        return YourLeagueListPage();
      case TabItem.profile:
        return Profile();
      case TabItem.login_screen:
        return const LoginPage();
      case TabItem.game_page:
        return const TestGame(null, null);
    }
    return Container();
  }

// BOTTTOM NAV BAR

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        _buildItem(icon: FontAwesomeIcons.home, tabItem: TabItem.feed),
        _buildItem(icon: FontAwesomeIcons.futbol, tabItem: TabItem.games),
        _buildItem(
            icon: FontAwesomeIcons.globeEurope, tabItem: TabItem.world_league),
        _buildItem(icon: FontAwesomeIcons.users, tabItem: TabItem.your_leagues),
        _buildItem(icon: FontAwesomeIcons.user, tabItem: TabItem.profile),
      ],
      onTap: _onSelectTab,
    );
  }

  BottomNavigationBarItem _buildItem({IconData icon, TabItem tabItem}) {
    final String text = tabItemName(tabItem);
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _colorTabMatching(item: tabItem),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: _colorTabMatching(item: tabItem),
        ),
      ),
    );
  }

  Color _colorTabMatching({TabItem item}) {
    return currentItem == item ? Theme.of(context).primaryColor : Colors.grey;
  }
}
