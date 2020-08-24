import 'package:ktg_client/model/team_info.dart';

class GameInfo {
  GameInfo(this.gameId, this.hometeam, this.awayteam, this.homescore,
      this.awayscore, this.datetime, this.onGoingTime, this.stadium) {
    if (homescore != null)
      homescore = homescore;
    else
      homescore = 0;
    if (awayscore != null)
      awayscore = awayscore;
    else
      awayscore = 0;

    if (datetime != null) {
      String date = datetime;
      date = date.substring(0, 10);
      this.date = date;
      date = datetime.substring(11, 16);
      datetime = date;
      onGoingTime = onGoingTime;


      
      
    }
  }
  int gameId;
  TeamInfo hometeam;
  TeamInfo awayteam;
  int homescore;
  int awayscore;
  String date;
  String datetime;
  String onGoingTime;
  String stadium;
}
