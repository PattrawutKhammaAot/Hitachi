class PMDailyModel {
  const PMDailyModel({
    this.ID,
    this.OPERATOR_NAME,
    this.CHECKPOINT,
    this.STATUS,
    this.STARTDATE,
  });
  final int? ID;
  final String? OPERATOR_NAME;
  final String? CHECKPOINT;
  final String? STATUS;
  final String? STARTDATE;

  List<Object> get props => [
        ID!,
        OPERATOR_NAME!,
        CHECKPOINT!,
        STATUS!,
        STARTDATE!,
      ];
  PMDailyModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        OPERATOR_NAME = map['OperatorName'],
        CHECKPOINT = map['CheckPointPM'],
        STATUS = map['Status'],
        STARTDATE = map['DatePM'];
}
