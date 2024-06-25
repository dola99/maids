class UserData {
  int id;
  String firstName;
  String lastName;
  String userName;
  String email;
  String gender;
  String image;
  String token;
  String refershToken;

  UserData._privateConstructor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userName,
    required this.gender,
    required this.image,
    required this.refershToken,
    required this.token,
  });

  // Singleton instance
  static final UserData _instance = UserData._privateConstructor(
      id: 0,
      firstName: '',
      lastName: '',
      email: '',
      gender: '',
      userName: '',
      image: '',
      refershToken: '',
      token: '');

  factory UserData.getInstance() {
    return _instance;
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    _instance.id = json['id'];
    _instance.firstName = json["firstName"];
    _instance.image = json["image"];
    _instance.lastName = json["lastName"];
    _instance.userName = json["username"];
    _instance.refershToken = json["refreshToken"];
    _instance.token = json["token"];
    _instance.email = json['email'];
    _instance.gender = json['gender'];
    return _instance;
  }
}
