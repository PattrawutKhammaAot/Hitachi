class TreatmentModel {
  const TreatmentModel({
    this.MATERIAL,
    this.OPERATOR_NAME,
    this.BATCH1,
    this.BATCH2,
    this.BATCH3,
    this.BATCH4,
    this.BATCH5,
    this.BATCH6,
    this.BATCH7,
    this.STARTDATE,
    this.FINDATE,
  });
  final String? MATERIAL;
  final String? OPERATOR_NAME;
  final String? BATCH1;
  final String? BATCH2;
  final String? BATCH3;
  final String? BATCH4;
  final String? BATCH5;
  final String? BATCH6;
  final String? BATCH7;
  final String? STARTDATE;
  final String? FINDATE;

  List<Object> get props => [
        MATERIAL!,
        OPERATOR_NAME!,
        BATCH1!,
        BATCH2!,
        BATCH3!,
        BATCH4!,
        BATCH5!,
        BATCH6!,
        BATCH7!,
        STARTDATE!,
        FINDATE!,
      ];
  TreatmentModel.fromMap(Map<String, dynamic> map)
      : MATERIAL = map['Machine'],
        OPERATOR_NAME = map['OperatorName'],
        BATCH1 = map['Bacth1'],
        BATCH2 = map['Bacth2'],
        BATCH3 = map['Bacth3'],
        BATCH4 = map['Bacth4'],
        BATCH5 = map['Bacth5'],
        BATCH6 = map['Bacth6'],
        BATCH7 = map['Bacth7'],
        STARTDATE = map['StartDate'],
        FINDATE = map['FinDate'];
}
