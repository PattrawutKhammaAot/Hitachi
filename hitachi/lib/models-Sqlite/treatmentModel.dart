class TreatmentModel {
  const TreatmentModel(
      {this.ID,
      this.MACHINE_NO,
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
      this.CHECK_COMPLETE,
      this.TEMP_CURVE,
      this.TREATMENT_TIME});
  final int? ID;
  final String? MACHINE_NO;
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
  final String? CHECK_COMPLETE;
  final String? TEMP_CURVE;
  final String? TREATMENT_TIME;

  List<Object> get props => [
        ID!,
        MACHINE_NO!,
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
        CHECK_COMPLETE!,
        TEMP_CURVE!,
        TREATMENT_TIME!,
      ];
  TreatmentModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        MACHINE_NO = map['MachineNo'],
        OPERATOR_NAME = map['OperatorName'],
        BATCH1 = map['Batch1'],
        BATCH2 = map['Batch2'],
        BATCH3 = map['Batch3'],
        BATCH4 = map['Batch4'],
        BATCH5 = map['Batch5'],
        BATCH6 = map['Batch6'],
        BATCH7 = map['Batch7'],
        STARTDATE = map['StartDate'],
        FINDATE = map['FinDate'],
        TEMP_CURVE = map['TempCurve'],
        TREATMENT_TIME = map['TreatmentTime'],
        CHECK_COMPLETE = map['CheckComplete'];
}
