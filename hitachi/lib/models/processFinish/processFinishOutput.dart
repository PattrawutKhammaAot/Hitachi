class ProcessFinishOutputModel {
  const ProcessFinishOutputModel({
    this.MACHINE,
    this.OPERATORNAME,
    this.REJECTQTY,
    this.BATCHNO,
    this.GARBAGE,
    this.FINISHDATE,
  });

  final String? MACHINE;
  final int? OPERATORNAME;
  final String? REJECTQTY;
  final int? BATCHNO;
  final String? GARBAGE;
  final String? FINISHDATE;

  ProcessFinishOutputModel copyWith({
    String? MACHINE,
    int? OPERATORNAME,
    String? REJECTQTY,
    int? BATCHNO,
    String? GARBAGE,
    String? FINISHDATE,
  }) {
    return ProcessFinishOutputModel(
      MACHINE: MACHINE ?? this.MACHINE,
      OPERATORNAME: OPERATORNAME ?? this.OPERATORNAME,
      REJECTQTY: REJECTQTY ?? this.REJECTQTY,
      BATCHNO: BATCHNO ?? this.BATCHNO,
      GARBAGE: GARBAGE ?? this.GARBAGE,
      FINISHDATE: FINISHDATE ?? this.FINISHDATE,
    );
  }

  @override
  Map toJson() => {
        'Machine': MACHINE,
        'OperatorName': OPERATORNAME,
        'RejectQty': REJECTQTY,
        'BatchNo': BATCHNO,
        'GARBAGE': GARBAGE,
        'FinishDate': FINISHDATE,
      };
}
