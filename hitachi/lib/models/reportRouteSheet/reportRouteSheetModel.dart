class ReportRouteSheetModel {
  const ReportRouteSheetModel({this.MESSAGE, this.RESULT});

  final bool? RESULT;
  final String? MESSAGE;

  List<Object> get props => [RESULT!, MESSAGE!];

  static ReportRouteSheetModel fromJson(dynamic json) {
    return ReportRouteSheetModel(
      RESULT: json['result'],
      MESSAGE: json['message'],
    );
  }
}
