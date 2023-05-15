class ProcessOutputModel {
  const ProcessOutputModel({
    this.MACHINE,
    this.OPERATORNAME,
    this.OPERATORNAME1,
    this.OPERATORNAME2,
    this.OPERATORNAME3,
    this.BATCHNO,
    this.STARTDATE,
  });

  final String? MACHINE;
  final String? OPERATORNAME;
  final String? OPERATORNAME1;
  final String? OPERATORNAME2;
  final String? OPERATORNAME3;
  final int? BATCHNO;
  final String? STARTDATE;

  ProcessOutputModel copyWith({
    String? MACHINE,
    String? OPERATORNAME,
    String? OPERATORNAME1,
    String? OPERATORNAME2,
    String? OPERATORNAME3,
    int? BATCHNO,
    String? STARTDATE,
  }) {
    return ProcessOutputModel(
      MACHINE: MACHINE ?? this.MACHINE,
      OPERATORNAME: OPERATORNAME ?? this.OPERATORNAME,
      OPERATORNAME1: OPERATORNAME1 ?? this.OPERATORNAME1,
      OPERATORNAME2: OPERATORNAME2 ?? this.OPERATORNAME2,
      OPERATORNAME3: OPERATORNAME3 ?? this.OPERATORNAME3,
      BATCHNO: BATCHNO ?? this.BATCHNO,
      STARTDATE: STARTDATE ?? this.STARTDATE,
    );
  }

  @override
  Map toJson() => {
        'Machine': MACHINE,
        'OperatorName': OPERATORNAME,
        'OperatorName1': OPERATORNAME1,
        'OperatorName2': OPERATORNAME2,
        'OperatorName3': OPERATORNAME3,
        'BatchNo': BATCHNO,
        'StartDate': STARTDATE,
      };
}
