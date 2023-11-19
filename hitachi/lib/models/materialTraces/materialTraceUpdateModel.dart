class MaterialTraceUpdateModel {
  const MaterialTraceUpdateModel(
      {this.MATERIAL,
      this.OPERATOR,
      this.BATCH_NO,
      this.PROCESS,
      this.LOT,
      this.DATE,
      this.ID,
      this.I_PEAK,
      this.HIGH_VOLT,
      this.IPE_NO});
  final int? ID;
  final String? MATERIAL;
  final String? OPERATOR;
  final String? BATCH_NO;
  final String? IPE_NO;
  final String? PROCESS;
  final String? LOT;
  final String? DATE;
  final int? I_PEAK;
  final int? HIGH_VOLT;

  List<Object> get props => [
        MATERIAL!,
        OPERATOR!,
        BATCH_NO!,
        PROCESS!,
        IPE_NO!,
        LOT!,
        DATE!,
        ID!,
        I_PEAK!,
        HIGH_VOLT!
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
        I_PEAK: json['Ipeak'],
        HIGH_VOLT: json['HighVolt'],
        IPE_NO: json['IPE_NO']);
  }

  MaterialTraceUpdateModel.fromMap(Map<String, dynamic> map)
      : MATERIAL = map['Material'],
        OPERATOR = map['Operator'],
        BATCH_NO = map['BATCH_NO'],
        PROCESS = map['PROCESS'],
        LOT = map['Lot'],
        DATE = map['Date'],
        I_PEAK = map['Ipeak'],
        HIGH_VOLT = map['HighVolt'],
        IPE_NO = map['IPE_NO'],
        ID = map['ID'];

  MaterialTraceUpdateModel copyWith(
      {String? MATERIAL,
      String? MACHINENO,
      int? OPERATORNAME,
      String? BATCHNO,
      String? LOT,
      String? STARTDATE,
      int? I_PEAK,
      int? HIGH_VOLT,
      String? IPE_NO}) {
    return MaterialTraceUpdateModel(
        MATERIAL: MATERIAL ?? this.MATERIAL,
        OPERATOR: OPERATOR ?? this.OPERATOR,
        BATCH_NO: BATCH_NO ?? this.BATCH_NO,
        PROCESS: PROCESS ?? this.PROCESS,
        LOT: LOT ?? this.LOT,
        DATE: DATE ?? this.DATE,
        I_PEAK: I_PEAK ?? this.I_PEAK,
        HIGH_VOLT: HIGH_VOLT ?? this.HIGH_VOLT,
        IPE_NO: IPE_NO ?? this.IPE_NO);
  }

  @override
  Map toJson() => {
        'Material': MATERIAL,
        'Operator': OPERATOR,
        'BATCH_NO': BATCH_NO,
        'PROCESS': PROCESS,
        'Lot': LOT,
        'Date': DATE,
        'Ipeak': I_PEAK,
        'HighVolt': HIGH_VOLT,
        'IPE_NO': IPE_NO,
      };
}
