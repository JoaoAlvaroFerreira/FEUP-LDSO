import 'package:ktg_client/model/league.dart';

class LeagueInvite {
  LeagueInvite(this.leagueId, this.sendId, this.receiverId, this.leagueName, this.membersCount);

  String leagueId;
  String sendId;
  String receiverId;
  String leagueName;
  List <LeagueMember> membersCount;
}
