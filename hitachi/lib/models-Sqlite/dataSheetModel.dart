class DataSheetTableModel {
  const DataSheetTableModel({
    this.PO_NO,
    this.IN_VOICE,
    this.FRIEGHT,
    this.INCOMING_DATE,
    this.STORE_BY,
    this.PACK_NO,
    this.STORE_DATE,
    this.STATUS,
    this.W1,
    this.W2,
    this.WEIGHT,
    this.MFG_DATE,
    this.THICKNESS,
    this.WRAP_GRADE,
    this.ROLL_NO,
    this.CHECK_COMPLETE,
  });
  final int? PO_NO;
  final String? IN_VOICE;
  final String? FRIEGHT;
  final String? INCOMING_DATE;
  final String? STORE_BY;
  final String? PACK_NO;
  final String? STORE_DATE;
  final String? STATUS;
  final num? W1;
  final num? W2;
  final num? WEIGHT;
  final String? MFG_DATE;
  final num? THICKNESS;
  final String? WRAP_GRADE;
  final num? ROLL_NO;
  final String? CHECK_COMPLETE;

  List<Object> get props => [
        PO_NO!,
        IN_VOICE!,
        FRIEGHT!,
        INCOMING_DATE!,
        STORE_BY!,
        PACK_NO!,
        STORE_DATE!,
        STATUS!,
        W1!,
        W2!,
        WEIGHT!,
        MFG_DATE!,
        THICKNESS!,
        WRAP_GRADE!,
        ROLL_NO!,
        CHECK_COMPLETE!,
      ];
  DataSheetTableModel.fromMap(Map<String, dynamic> map)
      : PO_NO = map['PO_NO'],
        IN_VOICE = map['INVOICE'],
        FRIEGHT = map['FRIEGHT'],
        INCOMING_DATE = map['INCOMING_DATE'],
        STORE_BY = map['STORE_BY'],
        PACK_NO = map['PACK_NO'],
        STORE_DATE = map['STORE_DATE'],
        STATUS = map['STATUS'],
        W1 = map['W1'],
        W2 = map['W2'],
        WEIGHT = map['WEIGHT'],
        MFG_DATE = map['MFG_DATE'],
        THICKNESS = map['THICKNESS'],
        WRAP_GRADE = map['WRAP_GRADE'],
        ROLL_NO = map['ROLL_NO'],
        CHECK_COMPLETE = map['checkComplete'];
}
