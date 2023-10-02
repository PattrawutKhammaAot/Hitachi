class ProcessOutputModel {
  const ProcessOutputModel({
    this.MACHINE,
    this.OPERATORNAME,
    this.OPERATORNAME1,
    this.OPERATORNAME2,
    this.OPERATORNAME3,
    this.BATCHNO,
    this.STARTDATE,
    this.STARTEND,
    this.PCW,
    this.HVT,
    this.ZINCK_THICKNESS,
    this.VISUAL_CONTROL,
    this.CLEARING_VOLTAGE,
  });

  final String? MACHINE;
  final int? OPERATORNAME;
  final int? OPERATORNAME1;
  final int? OPERATORNAME2;
  final int? OPERATORNAME3;
  final String? BATCHNO;
  final String? STARTDATE;
  final String? STARTEND;
  final String? PCW;
  final String? HVT;
  final String? ZINCK_THICKNESS;
  final String? VISUAL_CONTROL;
  final String? CLEARING_VOLTAGE;

  ProcessOutputModel copyWith({
    String? MACHINE,
    int? OPERATORNAME,
    int? OPERATORNAME1,
    int? OPERATORNAME2,
    int? OPERATORNAME3,
    String? BATCHNO,
    String? STARTDATE,
    String? STARTEND,
    String? PCW,
    String? HVT,
    String? ZINCK_THICKNESS,
    String? VISUAL_CONTROL,
    String? CLEARING_VOLTAGE,
  }) {
    return ProcessOutputModel(
      MACHINE: MACHINE ?? this.MACHINE,
      OPERATORNAME: OPERATORNAME ?? this.OPERATORNAME,
      OPERATORNAME1: OPERATORNAME1 ?? this.OPERATORNAME1,
      OPERATORNAME2: OPERATORNAME2 ?? this.OPERATORNAME2,
      OPERATORNAME3: OPERATORNAME3 ?? this.OPERATORNAME3,
      BATCHNO: BATCHNO ?? this.BATCHNO,
      STARTDATE: STARTDATE ?? this.STARTDATE,
      STARTEND: STARTEND ?? this.STARTEND,
      PCW: PCW ?? this.PCW,
      HVT: HVT ?? this.HVT,
      ZINCK_THICKNESS: ZINCK_THICKNESS ?? this.ZINCK_THICKNESS,
      VISUAL_CONTROL: VISUAL_CONTROL ?? this.VISUAL_CONTROL,
      CLEARING_VOLTAGE: CLEARING_VOLTAGE ?? this.CLEARING_VOLTAGE,
    );
  }

  @override
  Map toJson() => {
        'MachineNo': MACHINE,
        'OperatorName': OPERATORNAME,
        'OperatorName1': OPERATORNAME1,
        'OperatorName2': OPERATORNAME2,
        'OperatorName3': OPERATORNAME3,
        'BatchNo': BATCHNO,
        'StartDate': STARTDATE,
        'StartEnd': STARTEND,
        'PCW': PCW,
        'HVT': HVT,
        'ZINCK': ZINCK_THICKNESS,
        'VISUAL': VISUAL_CONTROL,
        'CLEARING': CLEARING_VOLTAGE,
      };
}
