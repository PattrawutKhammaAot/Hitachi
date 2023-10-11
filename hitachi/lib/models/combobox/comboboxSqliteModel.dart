class ComboboxSqliteModel {
  const ComboboxSqliteModel({
    this.VALUEMEMBER,
    this.GROUP,
  });
  final String? GROUP;
  final String? VALUEMEMBER;
  List<Object> get props => [GROUP!, VALUEMEMBER!];

  static ComboboxSqliteModel fromJson(dynamic json) {
    return ComboboxSqliteModel(
      GROUP: json['Group'],
      VALUEMEMBER: json['Value_Member'],
    );
  }

  ComboboxSqliteModel.fromMap(Map<String, dynamic> map)
      : GROUP = map['nameGroup'],
        VALUEMEMBER = map['valueMember'];
}
