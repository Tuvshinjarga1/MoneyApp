class Product{
  final String Vendorid;
  String id;
  final String zurag;
  final String ner;
  final String une;
  final String angilal;
  final String ded_angilal;
  final String nemelt_tailbar;
  final String belen_eseh;
  final String hugatsaa;
  final String too_shirheg;
  Product({
    this.Vendorid = '',
    this.id = '',
    required this.zurag,
    required this.ner,
    required this.une,
    required this.angilal,
    required this.ded_angilal,
    required this.nemelt_tailbar,
    required this.belen_eseh,
    required this.hugatsaa,
    required this.too_shirheg,
  });

  Map<String, dynamic> toJson() => {
    'Vendorid': Vendorid,
    'id': id,
    'Бүтээгдэхүүний зураг': zurag,
    'Нэр': ner,
    'Үнэ': une,
    'Ангилал': angilal,
    'Дэд ангилал': ded_angilal,
    'Тайлбар': nemelt_tailbar,
    'Бэлэн болох': belen_eseh,
    'Хугацаа': hugatsaa,
    'Тоо ширхэг': too_shirheg,
  };
}