class UserField {
  static const String email = 'email';
}

class User {
  String email;

  User({required this.email});

  Map<String, Object?> toJson() => {
        UserField.email: email,
      };

  static User fromJson(Map<String, Object?> json) =>
      User(email: json[UserField.email] as String);

  @override
  String toString() {
    // TODO: implement toString
    return email;
  }
}
