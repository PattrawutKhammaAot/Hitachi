class CheckWdsFinishInputModel {
  const CheckWdsFinishInputModel(
      {this.MESSAGE, this.RESULT, this.BATCHNO, this.IPE_NO});
  final String? BATCHNO;
  final bool? RESULT;
  final String? MESSAGE;
  final String? IPE_NO;

  List<Object> get props => [RESULT!, MESSAGE!, BATCHNO!, IPE_NO!];

  static CheckWdsFinishInputModel fromJson(dynamic json) {
    return CheckWdsFinishInputModel(
      BATCHNO: json['batchNo'],
      RESULT: json['result'],
      MESSAGE: json['message'],
      IPE_NO: json['ipeNo'],
    );
  }
}
