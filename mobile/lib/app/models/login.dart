class Login {
  String? _email;
  String? _password;
  String? _access_token;

  Login({String? email, String? password, String? access_token})
      : _email = email,
        _password = password,
        _access_token = access_token;

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password, 'access_token': access_token};
  }

  factory Login.fromJsonToken(Map<String, dynamic> json) {
    return Login(access_token: json['access_token']);
  }

  String? get email => _email;
  String? get password => _password;
  String? get access_token => _access_token;

  set email(String? email) {
    _email = email;
  }

  set password(String? password) {
    _password = password;
  }
}
