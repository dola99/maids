class UserData {
  int id;
  String firstName;
  String lastName;
  String username;
  String email;
  String gender;
  String image;
  String token;
  String refreshToken;

  UserData._privateConstructor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.gender,
    required this.image,
    required this.refreshToken,
    required this.token,
  });

  // Singleton instance
  static final UserData _instance = UserData._privateConstructor(
      id: 0,
      firstName: '',
      lastName: '',
      email: '',
      gender: '',
      username: '',
      image: '',
      refreshToken: '',
      token: '');

  factory UserData.getInstance() {
    return _instance;
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    _instance.id = json['id'];
    _instance.firstName = json["firstName"];
    _instance.image = json["image"];
    _instance.lastName = json["lastName"];
    _instance.username = json["username"];
    _instance.refreshToken = json["refreshToken"];
    _instance.token = json["token"];
    _instance.email = json['email'];
    _instance.gender = json['gender'];
    return _instance;
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.username == username &&
        other.gender == gender &&
        other.image == image &&
        other.token == token &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        username.hashCode ^
        gender.hashCode ^
        image.hashCode ^
        token.hashCode ^
        refreshToken.hashCode;
  }
}
