class User {
  int? _id;
  String _name;
  String _email;
  String? _password;
  List<String> _role;
  String? _img;

  User(
      {int? id,
      required String name,
      required String email,
      String? password,
      List<String>? role,
      String? img})
      : _id = id,
        _name = name,
        _email = email,
        _password = password,
        _role = role ?? [],
        _img = img;

  Map<String, dynamic> toMap() {
    if (id != null && id != -1) {
      return {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'img': img
      };
    } else {
      return {'name': name, 'email': email, 'password': password};
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      role: json['role'] != null ? List<String>.from(json['role']) : null,
      img: json['img'],
    );
  }

  int? get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password ?? '';
  List<String> get role => _role;
  String? get img => _img;

  set id(int? id) {
    _id = id;
  }

  set name(String name) {
    _name = name;
  }

  set email(String email) {
    _email = email;
  }

  set password(String password) {
    _password = password;
  }

  set role(List<String> role) {
    _role = role;
  }

  set img(String? img) {
    _img = img;
  }
}
