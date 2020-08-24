import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ktg_client/main.dart';
import 'package:ktg_client/view/login_page.dart';
import 'package:ktg_client/view/register_page.dart';
import 'package:mockito/mockito.dart';
import 'package:ktg_client/model/team_info.dart';
import 'package:ktg_client/model/game_info.dart';
//import 'package:ktg_client/view/match_card.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('Sample test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    expect(find.text('this text doesn\'t exist'), findsNothing);
  });



  testWidgets('Login test', (WidgetTester tester) async {
    NavigatorObserver mockObserver;
    mockObserver = MockNavigatorObserver();
    const LoginPage loginpage =  LoginPage();
    final MediaQuery app = MediaQuery(data:  const MediaQueryData(), child: MaterialApp(home: loginpage, navigatorObservers:  <NavigatorObserver>[mockObserver]));
    await tester.pumpWidget(app);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(MaterialButton), findsNWidgets(2));
    expect(find.byType(RaisedButton), findsOneWidget);

    final Finder email = find.widgetWithText(TextFormField, 'Enter Email');
    final Finder password = find.widgetWithText(TextFormField, 'Enter Password');
    final Finder button = find.widgetWithText(MaterialButton, 'Login');
    await tester.enterText(email, 'Jess');
    await tester.enterText(password, '1234fasf');
    await tester.tap(button);
    await tester.pump();
    expect(find.text('Please insert a valid email'), findsOneWidget);

    await tester.enterText(email, 'Jess@gmail.com');
    await tester.enterText(password, '');
    await tester.tap(button);
    await tester.pump();
    expect(find.text('Please enter your password'), findsOneWidget);

    await tester.enterText(email, 'thisaccountwillneverexist@forsure.cy');
    await tester.enterText(password, 'whyapassword123');
    await tester.tap(button);
    await tester.pump();
    expect(find.text('Wrong credentials'), findsOneWidget);

    await tester.enterText(email, 'jeremy@corbyn.co.uk');
    await tester.enterText(password, 'corbyn2020');
    await tester.tap(button);
    await tester.pump(const Duration(milliseconds: 1000));
    verify(mockObserver.didPush(any, any));


  });

  testWidgets('Register test', (WidgetTester tester) async {
    const RegisterPage registerpage =  RegisterPage();
    const MediaQuery app =  MediaQuery(data:  MediaQueryData(), child: MaterialApp(home: registerpage));
    await tester.pumpWidget(app);
    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(find.byType(MaterialButton), findsNWidgets(1));

    final Finder password = find.widgetWithText(TextFormField, 'Enter Password');
    final Finder confirmpassword = find.widgetWithText(TextFormField, 'Confirm Password');
    final Finder button = find.widgetWithText(MaterialButton, 'Confirm');
    await tester.tap(button);
    await tester.pump();
    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your username'), findsOneWidget);
    expect(find.text('Please insert a valid email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(find.text('Please make sure you typed the same password'), findsOneWidget);

    await tester.enterText(password, 'abc123');
    await tester.tap(button);
    await tester.pump();
    expect(find.text('Passwords should have at least 7 characters'), findsOneWidget);

    await tester.enterText(password, 'abc123');
    await tester.enterText(confirmpassword, 'abc321');
    await tester.tap(button);
    await tester.pump();
    expect(find.text('Passwords are not the same'), findsOneWidget);

  });

  testWidgets('Match Card test', (WidgetTester tester) async {
    final TeamInfo team1 = TeamInfo('Porto', 'FC Porto', 'test',1);
    final TeamInfo team2 = TeamInfo('Lisboa', 'SL Benfica', 'test', 2);
    final GameInfo gameinfo = GameInfo(12,team1,team2,0,2,'1212201911111111','40','Estadio do Dragao');

  /*
    final MatchCard matchcard = MatchCard(horizontal: true,isShimmered: false,gameInformation: gameinfo);

    Widget wrap() {
      return  Scaffold(body: matchcard);
    }
    final MediaQuery app =  MediaQuery(data:  const MediaQueryData(), child:  MaterialApp(home: wrap()));
    await tester.pumpWidget(app);


   */

    expect(gameinfo.hometeam.city, 'Porto');
    expect(gameinfo.awayteam.city, 'Lisboa');
    //expect(find.text('FC Porto'), findsWidgets);
    //expect(find.text('Lisboa'), findsWidgets);
    //expect(find.text('Estadio do Dragao'), findsWidgets);


  });
  
  /*
  testWidgets('Home page test', (WidgetTester tester) async {
    HomePage homepage = HomePage();
    final MediaQuery app =  MediaQuery(data:  const MediaQueryData(), child:  MaterialApp(home: homepage));
    await tester.pumpWidget(app);

    expect(find.text('Feed'), findsOneWidget);
    expect(find.text('games'), findsOneWidget);

    await tester.tap(find.text('world_league'));
    await tester.pumpAndSettle();
    expect(find.text('LeagueExample'), findsOneWidget);

  });

  test('GamesByDate', () async{
    final ApiHandler apitester = ApiHandler();
    await apitester.getNbaTeams();
    await apitester.getGamesByDate('2019-10-22');
    final GameInfo temp = apitester.getGames()[0];
    expect(temp.awayteam.name, 'New Orleans Pelicans');
    expect(temp.hometeam.name, 'Toronto Raptors');
    expect(temp.awayscore, 47);
    expect(temp.homescore, 51);
    expect(temp.date, '2019-10-22');
    expect(temp.datetime, '20:00');
  });

  test('NbaTeams', () async{
    final ApiHandler apitester = ApiHandler();
    await apitester.getNbaTeams();
    expect(apitester.teamName(1), 'Washington Wizards');
    expect(apitester.teamName(2), 'Charlotte Hornets');
    expect(apitester.teamName(3), 'Atlanta Hawks');
    expect(apitester.teamjson.length, 30);
  });

*/





}
