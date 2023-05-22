class PlanWindingOutputModel {
  const PlanWindingOutputModel({this.PROCESS});
  // PlanWindingOutputModel
  final List<PlanWindingOutputModelProcess>? PROCESS;

  List<Object> get props => [PROCESS!];

  static PlanWindingOutputModel fromJson(dynamic json) {
    return PlanWindingOutputModel(
      PROCESS: json['Process'] != null
          ? json['Process']
              .map((dynamic item) =>
                  PlanWindingOutputModelProcess.fromJson(item))
              .cast<PlanWindingOutputModelProcess>()
              .toList()
          : [],
    );
  }
}

class PlanWindingOutputModelProcess {
  const PlanWindingOutputModelProcess(
      {this.AMOUNT,
      this.FINISH_DATE,
      this.FINISH_TIME,
      this.ORDER,
      this.PROCESS,
      this.START_DATE,
      this.START_TIME});
  final int? ORDER;
  final String? PROCESS;
  final String? START_DATE;
  final String? START_TIME;
  final String? FINISH_DATE;
  final String? FINISH_TIME;
  final int? AMOUNT;
  List<Object> get props => [
        AMOUNT!,
        FINISH_DATE!,
        FINISH_TIME!,
        ORDER!,
        PROCESS!,
        START_DATE!,
        START_TIME!,
      ];

  static PlanWindingOutputModelProcess fromJson(dynamic json) {
    return PlanWindingOutputModelProcess(
      ORDER: json['Order'],
      PROCESS: json['Process'],
      START_DATE: json['START_DATE'],
      START_TIME: json['START_TIME'],
      FINISH_DATE: json['FINISH_DATE'],
      FINISH_TIME: json['FINISH_TIME'],
      AMOUNT: json['Amount'],
    );
  }
}
