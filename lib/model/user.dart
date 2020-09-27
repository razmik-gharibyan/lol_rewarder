class User {

  static final User _user = User._privateConstructor();

  factory User() {
    return _user;
  }

  User._privateConstructor();

  String _uid;

  String get uid => _uid;

  void setUid(String newValue) {
    _uid = newValue;
  }

}