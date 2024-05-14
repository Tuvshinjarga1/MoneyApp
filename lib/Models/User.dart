class User{
  String id;
  final String surname;
  final String name;
  final String phone;
  final String password;
  User({
    this.id = '',
    required this.surname,
    required this.name,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'Овог': surname,
    'Нэр': name,
    'Утас': phone,
    'Password': password,
  };
}