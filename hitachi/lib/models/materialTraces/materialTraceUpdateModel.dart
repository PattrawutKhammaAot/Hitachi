class MaterialTraceUpdateModel {
  const MaterialTraceUpdateModel(
      {this.MATERIAL,
      this.OPERATOR,
      this.BATCH_NO,
      this.PROCESS,
      this.LOT,
      this.DATE,
      this.ID});
  final int? ID;
  final String? MATERIAL;
  final String? OPERATOR;
  final String? BATCH_NO;
  final String? PROCESS;
  final String? LOT;
  final String? DATE;

  List<Object> get props => [
        MATERIAL!,
        OPERATOR!,
        BATCH_NO!,
        PROCESS!,
        LOT!,
        DATE!,
        ID!,
      ];

  static MaterialTraceUpdateModel fromJson(dynamic json) {
    return MaterialTraceUpdateModel(
      ID: json['ID'],
      MATERIAL: json['Material'],
      OPERATOR: json['Operator'],
      BATCH_NO: json['BATCH_NO'],
      PROCESS: json['PROCESS'],
      LOT: json['Lot'],
      DATE: json['Date'],
    );
  }

  MaterialTraceUpdateModel.fromMap(Map<String, dynamic> map)
      : MATERIAL = map['Material'],
        OPERATOR = map['Operator'],
        BATCH_NO = map['BATCH_NO'],
        PROCESS = map['PROCESS'],
        LOT = map['Lot'],
        DATE = map['Date'],
        ID = map['ID'];

  MaterialTraceUpdateModel copyWith({
    String? MATERIAL,
    String? MACHINENO,
    int? OPERATORNAME,
    String? BATCHNO,
    String? LOT,
    String? STARTDATE,
  }) {
    return MaterialTraceUpdateModel(
      MATERIAL: MATERIAL ?? this.MATERIAL,
      OPERATOR: OPERATOR ?? this.OPERATOR,
      BATCH_NO: BATCH_NO ?? this.BATCH_NO,
      PROCESS: PROCESS ?? this.PROCESS,
      LOT: LOT ?? this.LOT,
      DATE: DATE ?? this.DATE,
    );
  }

  @override
  Map toJson() => {
        'Material': MATERIAL,
        'Operator': OPERATOR,
        'BATCH_NO': BATCH_NO,
        'PROCESS': PROCESS,
        'Lot': LOT,
        'Date': DATE,
      };
}
