class MaterialInputLoadModel {
  const MaterialInputLoadModel({this.MATERIAL_MODEL});

  final List<MaterialModel>? MATERIAL_MODEL;

  List<Object> get props => [MATERIAL_MODEL!];

  static MaterialInputLoadModel fromJson(dynamic json) {
    return MaterialInputLoadModel(
      MATERIAL_MODEL: json['Material'] != null
          ? json['Material']
              .map((dynamic item) => MaterialModel.fromJson(item))
              .cast<MaterialModel>()
              .toList()
          : [],
    );
  }
}

class MaterialModel {
  const MaterialModel({this.TYPE, this.ITEM_CODE});
  final String? ITEM_CODE;
  final String? TYPE;
  List<Object> get props => [ITEM_CODE!, TYPE!];

  static MaterialModel fromJson(dynamic json) {
    return MaterialModel(ITEM_CODE: json['Itemcode'], TYPE: json['Type']);
  }
}
