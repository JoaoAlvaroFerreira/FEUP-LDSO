class User {
  User({this.data, this.name, this.email});
  User.full(this.data, this.name, this.email);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      data: <String, String>{'name': json['name'], 'email': json['email']},
      name: json['name'],
      email: json['email'],
    );
  }

  final Map<String, dynamic> data;
  final String name;
  final String email;

  String getName() {
    return name;
  }

  String getEmail() {
    return email;
  }
}
