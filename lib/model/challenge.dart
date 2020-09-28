class Challenge {

  static final Challenge _challenge = Challenge._privateConstructor();

  factory Challenge() {
    return _challenge;
  }

  Challenge._privateConstructor();

  String _type;

  String get type => _type;

  void setType(String newValue) {
    _type = newValue;
  }

}