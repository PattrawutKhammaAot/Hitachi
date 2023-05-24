class PMDailyCheckPointOutputModel {
  const PMDailyCheckPointOutputModel({
    this.STATUS,
    this.DESCRIPTION,
  });

  final String? STATUS;
  final String? DESCRIPTION;

  PMDailyCheckPointOutputModel copyWith({
    String? STATUS,
    String? DESCRIPTION,
  }) {
    return PMDailyCheckPointOutputModel(
      STATUS: STATUS ?? this.STATUS,
      DESCRIPTION: DESCRIPTION ?? this.DESCRIPTION,
    );
  }

  @override
  Map toJson() => {
        'Status': STATUS,
        'Description': DESCRIPTION,
      };
}
