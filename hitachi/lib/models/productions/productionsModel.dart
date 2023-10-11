class ProductionModel {
  const ProductionModel({
    this.JUMET,
    this.IPE,
    this.Film,
    this.Wind_Min,
    this.Wind_Avg,
    this.Wind_Max,
    this.Wind_Dia,
    this.Wind_Turn,
    this.Clearing,
    this.Treatment,
    this.Ipeak,
    this.HighVolt,
    this.Reactor,
    this.Measure_Min,
    this.Measure_Max,
    this.Tangent,
    this.BomP,
    this.SM,
    this.S1,
    this.S2,
  });
  final String? JUMET;
  final String? IPE;
  final int? Film;
  final num? Wind_Min;
  final num? Wind_Avg;
  final num? Wind_Max;
  final num? Wind_Dia;
  final num? Wind_Turn;
  final num? Clearing;
  final int? Treatment;
  final num? Ipeak;
  final num? HighVolt;
  final String? Reactor;
  final num? Measure_Min;
  final num? Measure_Max;
  final int? Tangent;
  final num? BomP;
  final String? SM;
  final String? S1;
  final String? S2;

  List<Object> get props => [
        JUMET!,
        IPE!,
        Film!,
        Wind_Min!,
        Wind_Avg!,
        Wind_Max!,
        Wind_Dia!,
        Wind_Turn!,
        Clearing!,
        Treatment!,
        Ipeak!,
        HighVolt!,
        Reactor!,
        Measure_Min!,
        Measure_Max!,
        Tangent!,
        BomP!,
        SM!,
        S1!,
        S2!,
      ];

  static ProductionModel fromJson(dynamic json) {
    return ProductionModel(
      JUMET: json['JUMET'],
      IPE: json['IPE'],
      Film: json['Film'],
      Wind_Min: json['Wind_Min'],
      Wind_Avg: json['Wind_Avg'],
      Wind_Max: json['Wind_Max'],
      Wind_Dia: json['Wind_Dia'],
      Wind_Turn: json['Wind_Turn'],
      Clearing: json['Clearing'],
      Treatment: json['Treatment'],
      Ipeak: json['Ipeak'],
      HighVolt: json['HighVolt'],
      Reactor: json['Reactor'],
      Measure_Min: json['Measure_Min'],
      Measure_Max: json['Measure_Max'],
      Tangent: json['Tangent'],
      BomP: json['BomP'],
      SM: json['SM'],
      S1: json['S1'],
      S2: json['S2'],
    );
  }

  ProductionModel.fromMap(Map<String, dynamic> map)
      : JUMET = map['JUMET'],
        IPE = map['IPE'],
        Film = map['Film'],
        Wind_Min = map['Wind_Min'],
        Wind_Avg = map['Wind_Avg'],
        Wind_Max = map['Wind_Max'],
        Wind_Dia = map['Wind_Dia'],
        Wind_Turn = map['Wind_Turn'],
        Clearing = map['Clearing'],
        Treatment = map['Treatment'],
        Ipeak = map['Ipeak'],
        HighVolt = map['HighVolt'],
        Reactor = map['Reactor'],
        Measure_Min = map['Measure_Min'],
        Measure_Max = map['Measure_Max'],
        Tangent = map['Tangent'],
        BomP = map['BomP'],
        SM = map['SM'],
        S1 = map['S1'],
        S2 = map['S2'];
}
