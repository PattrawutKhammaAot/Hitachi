class ProcessFinishOutputModel {
  const ProcessFinishOutputModel({
    this.MACHINE,
    this.OPERATORNAME,
    this.REJECTQTY,
    this.BATCHNO,
    this.FINISHDATE,
    this.ZINCK_THICKNESS,
    this.VISUAL_CONTROL,
    this.CLEARING_VOLTAGE,
    this.MISSING_RATIO,
    this.FILING_LEVEL,
  });

  final String? MACHINE;
  final int? OPERATORNAME;
  final int? REJECTQTY;
  final String? BATCHNO;

  final String? FINISHDATE;
  final String? ZINCK_THICKNESS;
  final String? VISUAL_CONTROL;
  final String? CLEARING_VOLTAGE;
  final String? MISSING_RATIO;
  final String? FILING_LEVEL;

  ProcessFinishOutputModel copyWith({
    String? MACHINE,
    int? OPERATORNAME,
    int? REJECTQTY,
    String? BATCHNO,
    String? FINISHDATE,
    String? ZINCK_THICKNESS,
    String? VISUAL_CONTROL,
    String? CLEARING_VOLTAGE,
    String? MISSING_RATIO,
    String? FILING_LEVEL,
  }) {
    return ProcessFinishOutputModel(
      MACHINE: MACHINE ?? this.MACHINE,
      OPERATORNAME: OPERATORNAME ?? this.OPERATORNAME,
      REJECTQTY: REJECTQTY ?? this.REJECTQTY,
      BATCHNO: BATCHNO ?? this.BATCHNO,
      FINISHDATE: FINISHDATE ?? this.FINISHDATE,
      ZINCK_THICKNESS: ZINCK_THICKNESS ?? this.ZINCK_THICKNESS,
      VISUAL_CONTROL: VISUAL_CONTROL ?? this.VISUAL_CONTROL,
      CLEARING_VOLTAGE: CLEARING_VOLTAGE ?? this.CLEARING_VOLTAGE,
      MISSING_RATIO: MISSING_RATIO ?? this.MISSING_RATIO,
      FILING_LEVEL: FILING_LEVEL ?? this.FILING_LEVEL,
    );
  }

  @override
  Map toJson() => {
        'MachineNo': MACHINE,
        'OperatorName': OPERATORNAME,
        'RejectQty': REJECTQTY,
        'BatchNo': BATCHNO,
        'FinishDate': FINISHDATE,
        'test': ZINCK_THICKNESS,
        'test1': VISUAL_CONTROL,
        'test2': CLEARING_VOLTAGE,
        'test3': MISSING_RATIO,
        'test4': FILING_LEVEL,
      };
}
