class DeleteMaterialTraceUpdateModel {
  const DeleteMaterialTraceUpdateModel({
    this.BATCH,
    this.PROCESS,
  });

  final String? BATCH;
  final String? PROCESS;

  List<Object> get props => [
        BATCH!,
        PROCESS!,
      ];

  static DeleteMaterialTraceUpdateModel fromJson(dynamic json) {
    return DeleteMaterialTraceUpdateModel(
      BATCH: json['batch'],
      PROCESS: json['process'],
    );
  }

  DeleteMaterialTraceUpdateModel copyWith({
    String? BATCH,
    String? PROCESS,
  }) {
    return DeleteMaterialTraceUpdateModel(
      BATCH: BATCH ?? this.BATCH,
      PROCESS: PROCESS ?? this.PROCESS,
    );
  }

  @override
  Map toJson() => {
        'batch': BATCH,
        'process': PROCESS,
      };
}
