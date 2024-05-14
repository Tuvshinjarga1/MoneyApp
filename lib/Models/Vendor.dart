class Vendor{
  String id;
  final String surname;
  final String name;
  final String work;
  final String registerNumber;
  final String phone;
  final String password;
  final String hayg;
  final String delgerengui;
  final String orshinSuugaa;
  final String tseejZurag;
  Vendor({
    this.id = '',
    required this.surname,
    required this.name,
    required this.work,
    required this.registerNumber,
    required this.phone,
    required this.password,
    required this.hayg,
    required this.delgerengui,
    required this.orshinSuugaa,
    required this.tseejZurag,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'Овог': surname,
    'Нэр': name,
    'Эрхэлдэг ажил': work,
    'Регистрийн дугаар': registerNumber,
    'Утас': phone,
    'Password': password,
    'Гэрийн хаяг': hayg,
    'Дэлгэрэнгүй': delgerengui,
    'Оршин суугаа газрын тдрлолт:': orshinSuugaa,
    'Цээж зураг': tseejZurag,
  };
}