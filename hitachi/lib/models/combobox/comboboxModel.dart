class ComboBoxModel {
  const ComboBoxModel(
      {this.VALUEMEMBER,
      this.GROUP,
      this.IS_ACTIVE,
      this.DESCRIPTION,
      this.COMBOBOX_ID,
      this.ID});
  final int? ID;
  final int? COMBOBOX_ID;
  final String? GROUP;
  final String? VALUEMEMBER;
  final String? DESCRIPTION;
  final bool? IS_ACTIVE;

  List<Object> get props =>
      [ID!, COMBOBOX_ID!, GROUP!, VALUEMEMBER!, IS_ACTIVE!];

  static ComboBoxModel fromJson(dynamic json) {
    return ComboBoxModel(
        COMBOBOX_ID: json['combobox_id'],
        GROUP: json['Group'],
        VALUEMEMBER: json['Value_Member'],
        IS_ACTIVE: json['Is_Active'],
        DESCRIPTION: json['Description']);
  }

  ComboBoxModel.fromMap(Map<String, dynamic> map)
      : GROUP = map['nameGroup'],
        VALUEMEMBER = map['valueMember'],
        IS_ACTIVE = map['IsActive'],
        DESCRIPTION = map['Description'],
        COMBOBOX_ID = map[''],
        ID = map['ID'];
}
