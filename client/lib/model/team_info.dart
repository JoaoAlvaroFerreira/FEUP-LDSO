class TeamInfo {
  TeamInfo(this.city, String name, this.logo, this.id) {
    if (city != null && name != null) this.name = city + ' ' + name;
  }

  String city;
  String name;
  String logo;
  int id;
  bool isShimmer;

  String getName() {
    return name;
  }

  String getLogo() {
    return logo;
  }

  int getId() {
    return id;
  }
}
