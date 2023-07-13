import 'package:mobile/app/models/user.dart';

class Property {
  int? _id;
  String _identifierName;
  double? _value;
  String? _ownerName;
  int? _numberProperty;
  String? _road;
  String? _neighborhood;
  String? _city;
  String? _state;
  String? _country;
  String? _zipCode;
  String? _description;
  String? _typeUse;
  String _typeMarketing;
  String? _img;
  User? _user;

  Property({
    int? id,
    required String identifierName,
    double? value,
    String? ownerName,
    int? numberProperty,
    String? road,
    String? neighborhood,
    String? city,
    String? state,
    String? country,
    String? zipCode,
    String? description,
    String? typeUse,
    required String typeMarketing,
    String? img,
    User? user,
  })  : _id = id,
        _identifierName = identifierName,
        _value = value,
        _ownerName = ownerName,
        _numberProperty = numberProperty,
        _road = road,
        _neighborhood = neighborhood,
        _city = city,
        _state = state,
        _country = country,
        _zipCode = zipCode,
        _description = description,
        _typeUse = typeUse,
        _typeMarketing = typeMarketing,
        _img = img,
        _user = user;

  Map<String, dynamic> toMap() {
    final map = {
      'identifier_name': identifierName,
      'value': value,
      'owner_name': ownerName,
      'number_property': numberProperty,
      'road': road,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'country': country,
      'zip_code': zipCode,
      'description': description,
      'type_use': typeUse,
      'type_marketing': typeMarketing,
      'img': img,
      'user': user?.toMap(),
    };

    if (id != null && id != -1) {
      map['id'] = id.toString();
    }
    return map;
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
        id: json['id'],
        identifierName: json['identifier_name'],
        value: double.parse(json['value']),
        ownerName: json['owner_name'],
        numberProperty: json['number_property'],
        road: json['road'],
        neighborhood: json['neighborhood'],
        city: json['city'],
        state: json['state'],
        country: json['country'],
        zipCode: json['zip_code'],
        description: json['description'],
        typeUse: json['type_use'],
        typeMarketing: json['type_marketing'],
        img: json['img']);
  }

  int get id => _id ?? -1;
  String get identifierName => _identifierName;
  double? get value => _value;
  String? get ownerName => _ownerName;
  int? get numberProperty => _numberProperty ?? 0;
  String? get road => _road;
  String? get neighborhood => _neighborhood;
  String? get city => _city;
  String? get state => _state;
  String? get country => _country;
  String? get zipCode => _zipCode;
  String? get description => _description;
  String? get typeUse => _typeUse;
  String get typeMarketing => _typeMarketing;
  String? get img => _img;
  User? get user => _user;

  getAddress() {
    String address = '';

    if (road != '' && road != null) {
      address = '${road ?? ''} ';
    }

    if (numberProperty != null) {
      address += '${numberProperty ?? ''} ';
    }

    if (neighborhood != '' &&
        neighborhood != null &&
        ((road != '' && road != null) || (numberProperty != null))) {
      address += '- ';
    }
    address += '${neighborhood ?? ''} ';

    return address;
  }

  getAddressCity() {
    String cityAddress = '';

    if (city != '' && city != null) {
      cityAddress = city ?? '';
      if (state != '' && state != null) {
        cityAddress += ', ${state ?? ''} ';
        if (country != '' && country != null) {
          cityAddress += '- ${country ?? ''} ';
        }
      }
    }

    return cityAddress;
  }

  set id(int id) {
    _id = id;
  }

  set identifierName(String identifierName) {
    _identifierName = identifierName;
  }

  set value(double? value) {
    _value = value;
  }

  set ownerName(String? ownerName) {
    _ownerName = ownerName;
  }

  set numberProperty(int? numberProperty) {
    _numberProperty = numberProperty;
  }

  set road(String? road) {
    _road = road;
  }

  set neighborhood(String? neighborhood) {
    _neighborhood = neighborhood;
  }

  set city(String? city) {
    _city = city;
  }

  set state(String? state) {
    _state = state;
  }

  set country(String? country) {
    _country = country;
  }

  set zipCode(String? zipCode) {
    _zipCode = zipCode;
  }

  set description(String? description) {
    _description = description;
  }

  set typeUse(String? typeUse) {
    _typeUse = typeUse;
  }

  set typeMarketing(String typeMarketing) {
    _typeMarketing = typeMarketing;
  }

  set img(String? img) {
    _img = img;
  }

  set user(User? user) {
    _user = user;
  }
}
