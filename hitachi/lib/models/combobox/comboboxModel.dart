class ComboBoxModel {
  const ComboBoxModel({this.VALUEMEMBER, this.GROUP, this.IS_ACTIVE});

  final String? GROUP;
  final String? VALUEMEMBER;
  final int? IS_ACTIVE;

  List<Object> get props => [GROUP!, VALUEMEMBER!, IS_ACTIVE!];

  static ComboBoxModel fromJson(dynamic json) {
    return ComboBoxModel(
        GROUP: json['result'],
        VALUEMEMBER: json['message'],
        IS_ACTIVE: json['']);
  }

  ComboBoxModel.fromMap(Map<String, dynamic> map)
      : GROUP = map['nameGroup'],
        VALUEMEMBER = map['valueMember'],
        IS_ACTIVE = map['IsActive'];
}
