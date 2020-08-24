class League {
  League(
      {this.leagueId,
      this.leagueName,
      this.leagueFounder,
      this.competition,
      List<LeagueMember> members}) {
    this.members = <LeagueMember>[];
    print(
        '************************************proof that it is the new code*************');
    for (int i = 0; i < members.length; i++) {
      this.members.add(members[i]);
    }
  }
  int leagueId;
  String leagueName;
  String leagueFounder; //e-mail
  String competition;
  List<LeagueMember> members;
}

class LeagueMember {
  LeagueMember(this.email, this.points) {
    points ??= 0;
  }
  String email;
  int points;
}
